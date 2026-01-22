import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["results"]
  static values = { query: String }

  connect() {
    // 検索クエリがある場合のみ実行
    if (this.queryValue) {
      this.fetchBookInfo()
    }
  }

  async fetchBookInfo() {
    const url = `https://www.googleapis.com/books/v1/volumes?q=${encodeURIComponent(this.queryValue)}`
    
    try {
      const response = await fetch(url)
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`)
      
      const data = await response.json()
      
      if (!data.items || data.items.length === 0) {
        this.resultsTarget.innerHTML = `<p class="text-center text-gray-500">該当する書籍が見つかりませんでした。</p>`
        return
      }

      // 配列をループしてHTMLを生成
      const html = data.items.map(item => this.bookTemplate(item)).join("")
      this.resultsTarget.innerHTML = html
      
    } catch (error) {
      console.error("取得失敗:", error)
      this.resultsTarget.innerHTML = `<p class="text-center text-red-500">データの取得に失敗しました。</p>`
    }
  }

  // 1件分の書籍データのHTMLテンプレート
  bookTemplate(item) {
    const info = item.volumeInfo
    const bookId = item.id // Google Booksの固有ID
    
    // データがない場合のデフォルト値を設定
    const thumbnail = info.imageLinks?.thumbnail || "https://via.placeholder.com/128x192?text=No+Image"
    const title = info.title || "タイトル不明"
    const authors = info.authors?.join(", ") || "著者不明"
    const description = info.description ? info.description.substring(0, 100) + "..." : "説明はありません。"

    // 詳細画面へのパス（Railsのルーティングに合わせて調整してください）
    // 例: /search/show?id=XYZ123
    const detailsPath = `/search/show/${bookId}`

    return `
      <div class="flex gap-4 p-4 bg-white border border-gray-200 rounded-xl shadow-sm mb-4 hover:shadow-md transition-shadow">
        <div class="flex-shrink-0 w-24 h-36 bg-gray-100 rounded-md overflow-hidden border">
          <img src="${thumbnail}" class="w-full h-full object-cover" alt="${title}" loading="lazy">
        </div>
        
        <div class="flex flex-col justify-between flex-grow">
          <div>
            <h3 class="font-bold text-gray-900 text-lg leading-tight line-clamp-2">${title}</h3>
            <p class="text-sm text-blue-600 mt-1">${authors}</p>
            <p class="text-xs text-gray-500 mt-2 line-clamp-3 leading-relaxed">${this.stripHtml(description)}</p>
          </div>
          
          <div class="mt-3 text-right">
            <a href="${detailsPath}" class="inline-block text-xs font-semibold py-2 px-4 border border-blue-600 text-blue-600 rounded-full hover:bg-blue-600 hover:text-white transition-colors">
              詳細を見る
            </a>
          </div>
        </div>
      </div>
    `
  }

  // HTMLタグを除去するユーティリティ
  stripHtml(html) {
    const doc = new DOMParser().parseFromString(html, 'text/html');
    return doc.body.textContent || "";
  }
}