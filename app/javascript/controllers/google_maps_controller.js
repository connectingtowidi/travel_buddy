import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="google-maps"
export default class extends Controller {
  async connect() {
    const markers = JSON.parse(this.element.dataset.markers);
    const position = { lat: 1.3521, lng: 103.8198 }; // Singapore

    const { Map } = await google.maps.importLibrary("maps");
    const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

    const map = new Map(this.element, {
      zoom: 12,
      center: position,
      mapId: "DEMO_MAP_ID",
    });

    markers.forEach(({ lat, lng, title }) => {
      new AdvancedMarkerElement({
        map: map,
        position: { lat, lng },
        title: title,
      });
    });
  }

  // static values = { apiKey: String, markersUrl: String };

  // async connect() {
  //   console.log("Google Maps Controller Connected!");

  //   // Load Google Maps library
  //   await this.loadGoogleMaps();

  //   // Fetch markers from the API
  //   const markers = await this.fetchMarkers();
    
  //   // Initialize the map
  //   this.initMap(markers);
  // }

  // async loadGoogleMaps() {
  //   if (!window.google) {
  //     const script = document.createElement("script");
  //     script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}&libraries=maps,marker`;
  //     script.async = true;
  //     document.head.appendChild(script);

  //     return new Promise((resolve) => {
  //       script.onload = resolve;
  //     });
  //   }
  // }

  // async fetchMarkers() {
  //   try {
  //     const response = await fetch(this.markersUrlValue);
  //     return await response.json();
  //   } catch (error) {
  //     console.error("Error fetching markers:", error);
  //     return [];
  //   }
  // }

  // async initMap(markers) {
  //   const { Map } = await google.maps.importLibrary("maps");
  //   const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

  //   const map = new google.maps.Map(this.element, {
  //     zoom: 4,
  //     center: markers.length > 0 ? markers[0] : { lat: -25.363, lng: 131.044 },
  //     mapId: "DEMO_MAP_ID",
  //   });

  //   markers.forEach((markerData) => {
  //     new AdvancedMarkerElement({
  //       position: { lat: markerData.lat, lng: markerData.lng },
  //       map,
  //       title: markerData.info_window,
  //     });
  //   });
  // }
}
