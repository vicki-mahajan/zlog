import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { currentUserId: Number }

  connect() {
    this.el = this.element
    if (!this.el) return

    this.isLoadingOlder = false
    this.previousScrollHeight = null
    this.previousScrollTop = null

    this.onClick = (event) => {
      const loadOlderLink = event.target.closest("[data-load-older-messages]")
      if (!loadOlderLink) return

      this.isLoadingOlder = true
      this.previousScrollHeight = this.el.scrollHeight
      this.previousScrollTop = this.el.scrollTop
    }

    this.el.addEventListener("click", this.onClick)

    this.styleExisting()

    this.scroll()

    this.observer = new MutationObserver((mutations) => {
      let addedMessageNode = false

      mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
          if (node.nodeType === 1 && node.hasAttribute("data-message-user-id")) {
            this.styleMessage(node)

            addedMessageNode = true

            if (!this.isLoadingOlder && !node.nextElementSibling) {
              setTimeout(() => this.scroll(), 10)
            }
          }
        })
      })

      if (this.isLoadingOlder && addedMessageNode && this.previousScrollHeight !== null) {
        const newScrollHeight = this.el.scrollHeight
        const delta = newScrollHeight - this.previousScrollHeight
        this.el.scrollTop = this.previousScrollTop + delta

        this.isLoadingOlder = false
        this.previousScrollHeight = null
        this.previousScrollTop = null
      }
    })

    this.observer.observe(this.el, { childList: true })
  }

  disconnect() {
    this.observer?.disconnect()
    if (this.onClick) {
      this.el.removeEventListener("click", this.onClick)
    }
  }

  styleExisting() {
    const msgs = this.el.querySelectorAll("[data-message-user-id]")
    msgs.forEach((el) => this.styleMessage(el))
  }

  styleMessage(el) {
    const uid = parseInt(el.getAttribute("data-message-user-id"))
    const mine = uid === this.currentUserIdValue

    // Bubble + label
    const bubble = el.querySelector(".message-bubble")
    const label = el.querySelector(".message-label")

    if (mine) {
      el.classList.remove("justify-content-start")
      el.classList.add("justify-content-end")

      if (bubble) bubble.style.background = "#d1e7ff"
      if (label) label.textContent = "You"
    } else {
      el.classList.remove("justify-content-end")
      el.classList.add("justify-content-start")

      if (bubble) bubble.style.background = "#d7f5dd"
    }
  }

  scroll() {
    this.el.scrollTop = this.el.scrollHeight
  }
}
