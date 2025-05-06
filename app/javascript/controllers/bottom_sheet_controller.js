import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bottomSheet", "content", "nonDraggable"]

  connect() {
    this.addEventListeners()
  }

  disconnect() {
    this.removeEventListeners()
  }

  addEventListeners() {
    this.bottomSheetTarget.addEventListener('touchstart', this.#dragStart.bind(this))
    this.bottomSheetTarget.addEventListener('touchmove', this.#dragMove.bind(this))
    this.bottomSheetTarget.addEventListener('touchend', this.#dragEnd.bind(this))
  }

  contentTargetConnected() {
    if (this.#isMobile()) {
      if (this.contentTarget.dataset.collapsed) {
        this.collapse()
      } else {
        this.bottomSheetTarget.style.height = "calc(100dvh - 256px)"
      }
    }
  }

  // only works with 1 nonDraggableTarget
  nonDraggableTargetConnected() {
    this.nonDraggableTarget.addEventListener('touchstart', this.#stopPropagationOnScroll.bind(this.nonDraggableTarget))
    this.nonDraggableTarget.addEventListener('touchmove', this.#stopPropagationOnScroll.bind(this.nonDraggableTarget))
    this.nonDraggableTarget.addEventListener('touchend', this.#stopPropagationOnScroll.bind(this.nonDraggableTarget))
  }

  removeEventListeners() {
    if (this.bottomSheetTarget) {
      this.bottomSheetTarget.removeEventListener('touchstart', this.#dragStart)
      this.bottomSheetTarget.removeEventListener('touchmove', this.#dragMove)
      this.bottomSheetTarget.removeEventListener('touchend', this.#dragEnd)
    }

    // if (this.nonDraggableTarget) {
    //   this.nonDraggableTarget.removeEventListener('touchstart', this.#stopPropagationOnScroll)
    //   this.nonDraggableTarget.removeEventListener('touchmove', this.#stopPropagationOnScroll)
    //   this.nonDraggableTarget.removeEventListener('touchend', this.#stopPropagationOnScroll)
    // }
  }

  collapse() {
    if (this.#isMobile()) {
      this.bottomSheetTarget.style.height = 0;
    }
  }

  #stopPropagationOnScroll(event) {
    event.stopPropagation()
  }

  #dragStart(event) {
    this.isDragging = false
    this.startY = event.touches[0].clientY
    this.currentY = this.startY
    this.startHeight = this.bottomSheetTarget.offsetHeight

    this.bottomSheetTarget.classList.remove('bottom-sheet-transition')
  }

  #dragMove(event) {
    event.preventDefault()
    
    this.isDragging = true

    const touch = event.touches[0]
    const deltaY = touch.clientY - this.currentY
  
    const newHeight = this.startHeight - deltaY
    this.bottomSheetTarget.style.height = `${newHeight}px`
  }

  #dragEnd() {
    this.bottomSheetTarget.classList.add('bottom-sheet-transition')

    if (!this.isDragging) return
    this.isDragging = false

    // Get the current height and compare to maxHeight
    const maxHeight = window.getComputedStyle(this.bottomSheetTarget).maxHeight.replace("px", "")
    const currentHeight = this.bottomSheetTarget.offsetHeight

    if (currentHeight < maxHeight / 2) {
      this.collapse()
    } else {
      this.bottomSheetTarget.style.height = `${maxHeight}px`
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