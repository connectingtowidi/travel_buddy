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
}
