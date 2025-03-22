import { Controller } from "@hotwired/stimulus";

let map;

// Connects to data-controller="google-maps"
export default class extends Controller {
  static targets = ["map", "attraction", "travel", "form", "durationResult"]

  static values = {
    lat: Number,
    lng: Number
  }

  routePath = null;

  ROUTES_URL = "https://routes.googleapis.com/directions/v2:computeRoutes"

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

    this.routePaths = {};
    this.toggleStates = {};
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

  fetchRoute(event) {
    // This is the AJAX request to fetch the route and duration
    console.log("Travel clicked")
    let clickedTravel = event.currentTarget;
    let travelId = clickedTravel.dataset.googleMapsToggleTravelIdValue;

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

        let travelId = clickedTravel.dataset.googleMapsToggleTravelIdValue;

        this.routePaths[travelId] = new Polyline({
          path: decodedPath,
          levels: decodedLevels,
          strokeColor: "#FF0000",
          strokeOpacity: 1.0,
          strokeWeight: 2,
          map: map
        });

        this.toggleStates[travelId] = "true";

        const newLat = (parseFloat(clickedTravel.dataset.googleMapsOriginLatValue) + parseFloat(clickedTravel.dataset.googleMapsDestinationLatValue)) / 2;
        const newLng = (parseFloat(clickedTravel.dataset.googleMapsOriginLngValue) + parseFloat(clickedTravel.dataset.googleMapsDestinationLngValue)) / 2;
        map.setCenter({ lat: newLat, lng: newLng });
        map.setZoom(13);
      })
      .catch(error => {
        console.error("Error fetching route:", error);
      });      
  }

  toggleRoute(event) {
    console.log("Toggle route clicked")
    // console.log(event.currentTarget.dataset.googleMapsToggleStateValue);
    // let clickedTravel = event.currentTarget;
    
    // let toggleState = clickedTravel.dataset.googleMapsToggleStateValue;
    // Clear existing route first, if any
    // if (this.routePath) {
    //   this.routePath.setMap(null)
    // }

    let travelId = event.currentTarget.dataset.googleMapsToggleTravelIdValue;
    console.log(travelId);

    if (this.toggleStates[travelId] === "true") {
      console.log("Clearing route")
      this.toggleStates[travelId] = "false";
      this.routePaths[travelId].setMap(null);
    } else {
      console.log("Fetching route")
      this.toggleStates[travelId] = "true";
      this.fetchRoute(event);
    }
  }

  fetchDuration(event) {
    event.preventDefault();
    console.log("Fetch duration clicked")
    const formId = event.currentTarget.closest('form').dataset.formId;
    const form = this.formTargets.find(
      form => form.dataset.formId === formId
    );
    // console.log(form);
    const formData = new FormData(form);
    // console.log(formData);

    // Find the corresponding result div for this form
    const resultDiv = this.durationResultTargets.find(
      target => target.dataset.formId === formId
    );

    // Show loading state
    resultDiv.innerHTML = '<span class="text-muted">Loading...</span>';

    fetch(form.action, {
      method: "POST",
      body: formData,
      headers: {
        "Accept": "application/json"
        // 'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.error) {
        resultDiv.innerHTML = `<span class="text-danger">Error: ${data.error}</span>`;
        return;
      }

      // Find the corresponding result div for this form
      const resultDiv = this.durationResultTargets.find(
        target => target.dataset.formId === formId
      );

      // Convert the times to Date objects and format them
      const startTime = new Date(data.start_travel_time);
      const endTime = new Date(data.end_travel_time);
      
      // Format the times in 12-hour format with AM/PM
      const formatTime = (date) => {
        return date.toLocaleTimeString('en-US', { 
          hour: '2-digit', 
          minute: '2-digit', 
          hour12: true,
          timeZone: 'Asia/Singapore'
        });
      };

      // Insert data into the result div
      resultDiv.innerHTML = 
        `${formatTime(startTime)} - ${formatTime(endTime)}`;
    })
    .catch(error => {
      console.error("Error fetching duration:", error);
    });    
  };

  
}
