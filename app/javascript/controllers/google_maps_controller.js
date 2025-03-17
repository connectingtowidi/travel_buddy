import { Controller } from "@hotwired/stimulus";

let map;

// Connects to data-controller="google-maps"
export default class extends Controller {
  static targets = ["map", "attraction", "travel"]

  static values = {
    lat: Number,
    lng: Number
  }

  async connect() {
    console.log(this.mapTarget)
    const markers = JSON.parse(this.mapTarget.dataset.markers);
    const position = { lat: 1.3521, lng: 103.8198 }; // Singapore

    const { Map } = await google.maps.importLibrary("maps");
    const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

    map = new Map(this.mapTarget, {
      zoom: 11,
      center: position,
      mapId: "DEMO_MAP_ID",
    });

    console.log(map)

    markers.forEach(({ lat, lng, title }) => {
      const marker = new AdvancedMarkerElement({
        map: map,
        position: { lat, lng },
        title: title,
      });

      marker.addListener("click", () => {
        map.setZoom(15);
        map.setCenter(marker.position);
      }); 
    });
  };  

  attraction(event) {
    console.log("Attraction clicked")
    let clickedAttraction = event.currentTarget;
    console.log(parseFloat(clickedAttraction.dataset.googleMapsLatValue));
    console.log(parseFloat(clickedAttraction.dataset.googleMapsLngValue));
    
    const position = { 
      lat: parseFloat(clickedAttraction.dataset.googleMapsLatValue), 
      lng: parseFloat(clickedAttraction.dataset.googleMapsLngValue) 
    };
    
    const URI = `https://maps.google.com/maps?ll=${position["lat"]},${position["lng"]}&z=11&t=m&hl=en-US&gl=US&mapclient=apiv3`

    map.setZoom(15);
    map.setCenter(position);
    
  }

  travel(event) {
    console.log("Travel clicked")
    let clickedTravel = event.currentTarget;
    // console.log(parseFloat(clickedTravel.dataset.googleMapsOriginLatValue));
    // console.log(parseFloat(clickedTravel.dataset.googleMapsOriginLngValue));
    // console.log(parseFloat(clickedTravel.dataset.googleMapsDestinationLatValue));
    // console.log(parseFloat(clickedTravel.dataset.googleMapsDestinationLngValue));

    const origin = {
      latitude: parseFloat(clickedTravel.dataset.googleMapsOriginLatValue),
      longitude: parseFloat(clickedTravel.dataset.googleMapsOriginLngValue)
    };

    const destination = { 
      latitude: parseFloat(clickedTravel.dataset.googleMapsDestinationLatValue),
      longitude: parseFloat(clickedTravel.dataset.googleMapsDestinationLngValue)
    };

    const mode = clickedTravel.dataset.googleMapsModeValue;

    console.log(origin);
    console.log(destination);
    console.log(mode);
    // Since GoogleMapsService.create_route likely returns a Promise
    // we need to use async/await or .then() to handle it properly
    
    fetch(`https://routes.googleapis.com/directions/v2:computeRoutes`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": "AIzaSyAa2xSve-KDw3OHTT8e_UZP08L3FyUPjVQ",
          "X-Goog-FieldMask": "routes.duration,routes.distanceMeters,routes.legs,routes.polyline.encodedPolyline"
        },
        body: JSON.stringify({
          "origin": {
            "location":{
              "latLng": {
                "latitude": origin["latitude"],
                "longitude": origin["longitude"]
              }
            }
          },
          "destination":{
            "location":{
              "latLng":{
                "latitude": destination["latitude"],
                "longitude": destination["longitude"]
              }
            }
          },
          "travelMode": mode,
          "computeAlternativeRoutes": false,
          "languageCode": "en-US",
          "units": "IMPERIAL"
        })
      })
      .then(response => response.json())
      .then(async (data) => {
        console.log(data);
        // polyline = data["routes"][0]["polyline"]["encodedPolyline"]
        const polyline = data["routes"][0]["polyline"]["encodedPolyline"]
        
        const { Polyline } = await google.maps.importLibrary("maps");
        const { encoding } = await google.maps.importLibrary("geometry");
        const geometry = { encoding };
        const decodedPath = geometry.encoding.decodePath(polyline);
        
        const encodedLevelsString = "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB";
        const decodedLevels = [];
        for (var i = 0; i < encodedLevelsString.length; ++i) {
            var level = encodedLevelsString.charCodeAt(i) - 63;
            decodedLevels.push(level);
        }

        const routePath = new Polyline({
          path: decodedPath,
          levels: decodedLevels,
          strokeColor: "#FF0000",
          strokeOpacity: 1.0,
          strokeWeight: 2,
          map: map
        });
      })
      .catch(error => {
        console.error("Error fetching route:", error);
      });

      
  }


  
}
