// app/javascript/controllers/new_post_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["npost"]

  // 表示・非表示を切り替える
  toggle() {
    this.npostTarget.classList.toggle("hidden")
  }
}