import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.handleStream = this.handleStream.bind(this)
    document.addEventListener("turbo:before-stream-render", this.handleStream)

    this.resizeObserver = new ResizeObserver(() => this.queueScroll())
    this.resizeObserver.observe(this.element)

    this.queueScroll()
  }

  disconnect() {
    document.removeEventListener("turbo:before-stream-render", this.handleStream)
    this.resizeObserver?.disconnect()
    if (this.frame) cancelAnimationFrame(this.frame)
  }

  handleStream(event) {
    const streamTarget = event.target.getAttribute("target")
    const messagesEl = this.element.querySelector('[data-chat-target="messages"]')
    const messagesId = messagesEl?.id

    if (streamTarget !== this.element.id && streamTarget !== messagesId && !this._shouldFocus) return

    const render = event.detail.render
    event.detail.render = (streamElement) => {
      render(streamElement)
      this.queueScroll()

      this.focusAfterScroll = true
      this._shouldFocus = false
    }
  }

  queueScroll() {
    if (this.frame) return

    this.frame = requestAnimationFrame(() => {
      this.scrollToBottom()
      this.frame = null

      if (this.focusAfterScroll) {
        const input = this.element.querySelector('input[type="text"], textarea')
        if (input) input.focus()
        this.focusAfterScroll = false
      }
    })
  }

  scrollToBottom() {
    const lastMessage = this.element.lastElementChild
    if (lastMessage) {
      lastMessage.scrollIntoView({ block: "end" })
    }
  }
}
