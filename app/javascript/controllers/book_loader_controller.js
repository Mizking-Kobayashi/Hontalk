//ここのStimulusを使ったコードはgeminiによるAI生成

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["title", "authors", "thumbnail", "description"]
  static values = { apiKey: String }

  connect() {
    this.fetchBookInfo()
  }

  async fetchBookInfo() {
    const url = `https://www.googleapis.com/books/v1/volumes/${this.apiKeyValue}`
    try {
      const response = await fetch(url)
      const data = await response.json()
      const info = data.volumeInfo

      if (this.hasTitleTarget) this.titleTarget.textContent = info.title
      if (this.hasAuthorsTarget) this.authorsTarget.textContent = info.authors?.join(", ")
      if (this.hasDescriptionTarget) this.descriptionTarget.textContent = info.description
      if (this.hasThumbnailTarget && info.imageLinks?.thumbnail) {
        this.thumbnailTarget.innerHTML = `<img class="w-full h-full object-cover" src="${info.imageLinks.thumbnail}">`
      }
    } catch (error) {
      console.error("取得失敗:", error)
    }
  }
}