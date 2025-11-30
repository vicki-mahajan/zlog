import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { currentUserId: Number }

  connect() {
    this.el = this.element
    if (!this.el) return

    this.styleExisting()

    this.scroll()

    this.observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
          if (node.nodeType === 1 && node.hasAttribute("data-message-user-id")) {
            this.styleMessage(node)

            if (!node.nextElementSibling) {
              setTimeout(() => this.scroll(), 10)
            }
          }
        })
      })
    })

    this.observer.observe(this.el, { childList: true })
  }

  disconnect() {
    this.observer?.disconnect()
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
