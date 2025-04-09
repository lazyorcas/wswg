// https://docs.mapbox.com/mapbox-gl-js/api/
// https://docs.mapbox.com/mapbox-gl-js/example/

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values = {
    accessToken: String,
    sourceUrl: String,
    centerCoordinates: Array,
    infoWindowHtmlTemplate: String
  }

  connect() {
    mapboxgl.accessToken = this.accessTokenValue

    this.map = new mapboxgl.Map({
      container: this.containerTarget,
      center: this.centerCoordinatesValue,
      // https://docs.mapbox.com/api/maps/styles/
      style: this.getMapStyle(),
      // https://docs.mapbox.com/help/glossary/zoom-level/
      zoom: 15,
      minZoom: 13,
      maxZoom: 17
    })

    this.map.on('load', async () => {
      this.addSource({
        id: 'initial-items',
        url: this.sourceUrlValue
      })
    })
  }

  disconnect() {
    this.map.remove()
  }

  getMapStyle() {
    const currentHour = new Date().getHours()
    return currentHour >= 6 && currentHour < 18
      ? 'mapbox://styles/mapbox/light-v11'
      : 'mapbox://styles/mapbox/dark-v11'
  }

  addSource(params) {
    const sourceId = params.id
    const sourceUrl = params.url

    this.map.addSource(sourceId, {
      type: 'geojson',
      data: sourceUrl
    })
    
    this.#addLayer(sourceId)
    this.#addClickEventListeners(sourceId)
    this.#addMouseEventListeners(sourceId)
  }

  #addLayer(sourceId) {
    this.map.addLayer({
      'id': sourceId,
      'source': sourceId,
      'type': 'circle',
      'paint': {
        'circle-radius': 8,
        'circle-color': '#FF0000',
        'circle-opacity': 0.5
      }
    })
  }

  #addClickEventListeners(sourceId) {
    this.map.on('click', sourceId, (item) => {
      const feature = item.features[0]

      new mapboxgl.Popup({
        anchor: 'right',
        closeButton: false,
        closeOnClick: true
      })
      .setLngLat(feature.geometry.coordinates)
      .setHTML(this.#buildInfoWindowHtml(feature))
      .addTo(this.map)
    })
  }

  #buildInfoWindowHtml(feature) {
    let s = this.infoWindowHtmlTemplateValue;
    const properties = feature.properties;

    for(let propertyKey in properties) {
      s = s.replace(new RegExp('{'+ propertyKey +'}','g'), properties[propertyKey]);
    }

    return s;
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