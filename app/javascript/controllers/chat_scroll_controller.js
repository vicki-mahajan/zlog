import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const el = document.getElementById("messages")
    if (!el) return

    el.scrollTop = el.scrollHeight
  }
}
