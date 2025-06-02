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
    this.itemSources = ["Meetup", "Luma", "Eventbrite", "MuenchenDe", "Ticketmaster"]

    mapboxgl.accessToken = this.accessTokenValue

    this.map = new mapboxgl.Map({
      container: this.containerTarget,
      center: this.centerCoordinatesValue,
    
      style: this.getMapStyle(),
    
      zoom: 15,
      minZoom: 11,
      maxZoom: 17
    })

    this.geolocateControl = new mapboxgl.GeolocateControl({
      positionOptions: {
        enableHighAccuracy: true
      },
      showUserHeading: true,
      trackUserLocation: true,
    })
    this.map.addControl(this.geolocateControl)

    this.map.on("load", async () => {
      this.#addSource()

      navigator.geolocation.getCurrentPosition(() => {
        this.geolocateControl.trigger()
      }, () => {
        const features = this.#getFeaturesFromItemTargets()
        if (features.length > 0) {
          this.#goTo(features[0].geometry.coordinates)
        }
      })
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

      // const features = this.#getFeaturesFromItemTargets()
      // if (features.length > 0) {
      //   this.#goTo(features[0].geometry.coordinates)
      // }
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
        this.map.loadImage(`/sources/${this.#underscore(source)}.ico`, (error, image) => {
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
        "icon-image": [
          "get",
          "source_name"
        ],
        "icon-size": [
          "get",
          "source_icon_multiplier"
        ],
      },
    })
  }

  #getFeaturesFromItemTargets() {
    return this.itemTargets.map(item => JSON.parse(item.dataset.mapFeature))
  }

  #showFeaturePopup(feature) {
    this.#closeActivePopup()

    const coordinates = feature.geometry.coordinates || this.map.getCenter()

    this.#goTo(coordinates)

    this.activePopup = new mapboxgl.Popup({
      anchor: this.#isMobile() ? "bottom" : "left",
      closeButton: false,
      closeOnClick: true,
      maxWidth: this.#isMobile() ? "90vw" : "354px"
    })

    this.activePopup
      .setLngLat(coordinates)
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

  #goTo(coordinates) {
    const distance = this.#calculateDistanceInKm(
      this.map.getCenter().toArray(), 
      coordinates
    )

    const options = {
      center: coordinates,
      padding: { 
        left: this.#isMobile() ? 0 : 256,
        top: this.#isMobile() ? 256 : 0
      }
    }

    if (distance > 100) {
      this.map.jumpTo(options)
    } else {
      this.map.flyTo(options)
    }
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

  #underscore(str) {
    return str
      .replace(/([A-Z])/g, '_$1')
      .replace(/^_/, '')         
      .toLowerCase();
  }

  #calculateDistanceInKm(coords1, coords2) {
    const lat1 = coords1[1] * Math.PI / 180
    const lon1 = coords1[0] * Math.PI / 180
    const lat2 = coords2[1] * Math.PI / 180
    const lon2 = coords2[0] * Math.PI / 180

    const dlat = lat2 - lat1
    const dlon = lon2 - lon1

    const a = Math.sin(dlat / 2) ** 2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlon / 2) ** 2
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    const d = 6371 * c

    return d
  }
}