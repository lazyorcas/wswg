// https://docs.mapbox.com/mapbox-gl-js/api/
// https://docs.mapbox.com/mapbox-gl-js/example/

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "item"]
  static values = {
    accessToken: String,
    centerCoordinates: Array,
    darkMode: Boolean
  }

  connect() {
    if (this.hasContainerTarget) {
      mapboxgl.accessToken = this.accessTokenValue

      this.map = new mapboxgl.Map({
        container: this.containerTarget,
        center: this.centerCoordinatesValue,
        // https://docs.mapbox.com/api/maps/styles/
        style: this.getMapStyle(),
        // https://docs.mapbox.com/help/glossary/zoom-level/
        zoom: 15,
        minZoom: 11,
        maxZoom: 17
      })

      this.map.on('load', async () => {
        this.addSource()
      })
    }
  }

  disconnect() {
    if (this.map) {
      this.map.remove()
    }
  }

  getMapStyle() {
    return this.darkModeValue
      ? 'mapbox://styles/mapbox/dark-v11'
      : 'mapbox://styles/mapbox/light-v11'
  }

  addSource() {
    const sourceId = 'items'
    const features = this.itemTargets.map(item => JSON.parse(item.dataset.mapFeature))

    this.map.addSource(sourceId, {
      type: 'geojson',
      data: {
        type: 'FeatureCollection',
        features: features
      }
    })
    
    this.#addLayer(sourceId)
    this.#addClickEventListeners(sourceId)
    this.#addMouseEventListeners(sourceId)

    // zoom to fit all features
    this.map.on('sourcedata', (e) => {
      if (e.sourceId === sourceId) {
        const coordinates = features.map(feature => feature.geometry.coordinates)
        const bounds = new mapboxgl.LngLatBounds(coordinates[0], coordinates[1])
        coordinates.forEach(coordinate => bounds.extend(coordinate))
        this.map.fitBounds(bounds, {
          padding: {
            top: 128,
            bottom: 128,
            left: 640,
            right: 128
          }
        })
      }
    })
  }

  removeAllPopups() {
    const popups = document.getElementsByClassName("mapboxgl-popup")
    for (let popup of popups) {
      popup.remove();
    }
  }

  showFeaturePopupOnHover(e) {
    const feature = JSON.parse(e.target.dataset.mapFeature)
    this.#showFeaturePopup(feature)
  }

  #showFeaturePopup(feature) {
    this.map.flyTo({
      center: feature.geometry.coordinates,
      padding: {
        left: 320
      }
    });

    new mapboxgl.Popup({
      anchor: 'left',
      closeButton: false,
      closeOnClick: true,
      maxWidth: '320px'
    })
    .setLngLat(feature.geometry.coordinates)
    .setHTML(this.#buildInfoWindowHtml(feature))
    .addTo(this.map)
  }

  #addLayer(sourceId) {
    this.map.addLayer({
      'id': sourceId,
      'source': sourceId,
      'type': 'circle',
      'paint': {
        'circle-radius': 8,
        'circle-opacity': 0.5,
        // https://docs.mapbox.com/mapbox-gl-js/example/data-driven-circle-colors/
        'circle-color': [
          'match',
          ['get', 'dow'],
          '1', '#FFFF00', // yellow
          '2', '#FFC0CB', // pink
          '3', '#008000', // green
          '4', '#FFA500', // orange
          '5', '#0000FF', // blue
          '6', '#800080', // purple
          '7', '#FF0000', // red
          '#FF0000'
        ]
      }
    })
  }

  #addClickEventListeners(sourceId) {
    this.map.on('click', sourceId, (item) => {
      const feature = item.features[0]

      this.#showFeaturePopup(feature)
    })
  }

  #buildInfoWindowHtml(feature) {
    return `<turbo-frame id="${feature.properties.dom_id}" src="${feature.properties.info_window_path}"></turbo-frame>`
  }

  #addMouseEventListeners(sourceId) {
    this.map.on('mouseenter', sourceId, () => {
      this.map.getCanvas().style.cursor = 'pointer'
    })

    this.map.on('mouseleave', sourceId, () => {
      this.map.getCanvas().style.cursor = ''
    })
  }
}