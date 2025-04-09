// https://docs.mapbox.com/api/maps/styles/
// https://docs.mapbox.com/mapbox-gl-js/api/
// https://docs.mapbox.com/mapbox-gl-js/example/

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values = {
    accessToken: String,
    sourcePath: String,
    center: Array
  }

  connect() {
    mapboxgl.accessToken = this.accessTokenValue

    this.map = new mapboxgl.Map({
      container: this.containerTarget,
      style: this.getMapStyle(),
      center: this.centerValue,
      zoom: 9
    })

    // this.map.on('sourcedata', (e) => {
    //   if (e.sourceId === 'items' && e.isSourceLoaded) {
    //     const features = this.map.querySourceFeatures(e.sourceId)

    //     // add all icons to the map
    //     features.forEach((feature) => {
    //       this.map.addImage(feature.properties.icon, feature.properties.icon)
    //     })
    //   }
    // })

    this.map.on('load', async () => {
      this.map.addSource('items', {
        type: 'geojson',
        data: "http://localhost:3000/searches/4183d445-a3f8-4f1e-a44e-43ee73b758d2.geojson"
      })

      this.map.addLayer({
        'id': 'items',
        'source': 'items',
        'type': 'circle',
        'paint': {
          'circle-radius': 8,
          'circle-color': '#FF0000',
          'circle-opacity': 0.7
        }
        // 'type': 'symbol',
        // 'layout': {
        //   'icon-image': '{icon}',
        // }
      })

      this.handlePopup()
    })
  }

  getMapStyle() {
    const currentHour = new Date().getHours()
    // Use light style between 6 AM and 6 PM (6-18)
    return currentHour >= 6 && currentHour < 18
      ? 'mapbox://styles/mapbox/light-v11'
      : 'mapbox://styles/mapbox/dark-v11'
  }

  handlePopup() {
    this.map.on('click', 'items', (e) => {
      const coordinates = e.features[0].geometry.coordinates.slice();

      new mapboxgl.Popup({
        anchor: 'right',
        closeButton: false,
        closeOnClick: true
      })
      .setLngLat(coordinates)
      .setHTML(e.features[0].properties.html)
      .addTo(this.map)
    })
  }
}