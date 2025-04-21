// https://docs.mapbox.com/mapbox-gl-js/api/
// https://docs.mapbox.com/mapbox-gl-js/example/

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "item", "source"]
  static values = {
    accessToken: String,
    centerCoordinates: Array
  }

  connect() {
    this.activePopup = null
    this.sourceId = "items"
    this.itemSources = ["Meetup", "Luma", "Eventbrite"]

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

    this.map.on("load", async () => {
      this.#addSource()
      
      const features = this.#getFeaturesFromItemTargets()
      if (features.length > 0) {
        this.#flyTo(features[0].geometry.coordinates)
      }
    })
  }

  disconnect() {
    if (this.map) {
      this.map.remove()
    }
  }

  getMapStyle() {
    return window.matchMedia("(prefers-color-scheme: dark)").matches
      ? "mapbox://styles/mapbox/dark-v11"
      : "mapbox://styles/mapbox/light-v11"
  }

  showFeaturePopup(e) {
    const feature = JSON.parse(e.target.dataset.mapFeature)
    this.#showFeaturePopup(feature)
  }

  sourceTargetConnected() {
    const source = this.map.getSource(this.sourceId);
    if (source) {
      this.#closeActivePopup()

      source.setData({
        type: "FeatureCollection",
        features: this.#getFeaturesFromItemTargets()
      })

      const features = this.#getFeaturesFromItemTargets()
      if (features.length > 0) {
        this.#flyTo(features[0].geometry.coordinates)
      }
    }
  }

  #addSource() {
    this.map.addSource(this.sourceId, {
      type: "geojson",
      data: {
        type: "FeatureCollection",
        features: this.#getFeaturesFromItemTargets()
      }
    })
    
    this.#addLayer()
    this.#addClickEventListeners()
    this.#addMouseEventListeners()
  }

  async #addLayer() {
    const imagePromises = this.itemSources.map(source => {
      return new Promise((resolve, reject) => {
        this.map.loadImage(`/sources/${source.toLowerCase()}.ico`, (error, image) => {
          if (error) reject(error);
          this.map.addImage(source, image);
          resolve();
        });
      });
    });

    await Promise.all(imagePromises);

    this.map.addLayer({
      "id": this.sourceId,
      "source": this.sourceId,
      "type": "symbol",
      "layout": {
        // https://docs.mapbox.com/mapbox-gl-js/example/add-image/
        // https://docs.mapbox.com/mapbox-gl-js/example/data-driven-circle-colors/
        "icon-image": [
          "get",
          "source_name"
        ],
        "icon-size": [
          "get",
          "source_icon_multiplier"
        ],
      },
      // "paint": {
      //   "icon-opacity": 0.5
      // }
    })
  }

  #getFeaturesFromItemTargets() {
    return this.itemTargets.map(item => JSON.parse(item.dataset.mapFeature))
  }

  #showFeaturePopup(feature) {
    this.#closeActivePopup()

    this.#flyTo(feature.geometry.coordinates)

    this.activePopup = new mapboxgl.Popup({
      anchor: this.#isMobile() ? "bottom" : "left",
      closeButton: false,
      closeOnClick: true,
      maxWidth: this.#isMobile() ? "80vw" : "320px"
    })

    this.activePopup
      .setLngLat(feature.geometry.coordinates)
      .setHTML(this.#buildInfoWindowHtml(feature))
      .addTo(this.map)
  }

  #buildInfoWindowHtml(feature) {
    return `<turbo-frame id="${feature.properties.dom_id}" src="${feature.properties.info_window_path}"></turbo-frame>`
  }

  #addClickEventListeners() {
    this.map.on("click", this.sourceId, (item) => {
      const feature = item.features[0]
      this.#showFeaturePopup(feature)
    })
  }

  #addMouseEventListeners() {
    this.map.on("mouseenter", this.sourceId, () => {
      this.map.getCanvas().style.cursor = "pointer"
    })

    this.map.on("mouseleave", this.sourceId, () => {
      this.map.getCanvas().style.cursor = ""
    })
  }

  #flyTo(coordinates) {
    this.map.flyTo({
      center: coordinates,
      padding: { 
        left: this.#isMobile() ? 0 : 320,
        top: this.#isMobile() ? 480 : 0
      }
    })
  }

  #closeActivePopup() {
    if (this.activePopup && this.activePopup.isOpen()) {
      this.activePopup.remove()
    }
  }

  #isMobile() {
    const breakpoint = this.#getCurrentBreakpoint()
    return ["xs", "sm"].includes(breakpoint)
  }

  // https://tailwindcss.com/docs/responsive-design
  #getCurrentBreakpoint() {
    const breakpoints = {
      'sm': '40rem',
      'md': '48rem',
      'lg': '64rem',
      'xl': '80rem',
      '2xl': '96rem'
    }
  
    return Object.entries(breakpoints)
      .reverse()
      .find(([_, width]) => window.matchMedia(`(min-width: ${width})`).matches)?.[0] || 'xs'
  }
}