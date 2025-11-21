import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.el = document.getElementById("messages")
    if (!this.el) return

    this.scrollToBottom()
    document.addEventListener("turbo:before-stream-render", this.handleTurboRender)
  }

  disconnect() {
    document.removeEventListener("turbo:before-stream-render", this.handleTurboRender)
  }

  handleTurboRender = (event) => {
    if (event.target.action === "append" && event.target.target === "messages") {
      setTimeout(() => this.scrollToBottom(), 10)
    }
  }

  scrollToBottom() {
    this.el.scrollTop = this.el.scrollHeight
  }
}
