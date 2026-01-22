require "net/http"
require "json"

class LibrariesController < ApplicationController
  before_action :set_library, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  # GET /libraries or /libraries.json
  def index
    @libraries = current_user.libraries
  end

  # GET /libraries/1 or /libraries/1.json
  def show
    @library = Library.find(params[:id])
  end

  # GET /libraries/new
  def new
    @library = Library.new
  end

  # GET /libraries/1/edit
  def edit
  end

  # POST /libraries or /libraries.json
  def create
    # 重要：ここで library_params を使ってはいけません！
    # 直接 params[:api_str] を使うように書き換えます。
    @library = Library.new(api_str: params[:api_str])
    @library.user_id = current_user.id

    respond_to do |format|
      if @library.api_str.present?
        begin
          # APIを叩いてタイトルを取得
          url = URI.parse("https://www.googleapis.com/books/v1/volumes/#{@library.api_str}")
          response = Net::HTTP.get(url)
          data = JSON.parse(response)
          @library.title = data.dig("volumeInfo", "title")
        rescue => e
          logger.error "Google Books API Error: #{e.message}"
        end
      end

      if @library.save
        format.html { redirect_to @library, notice: "ライブラリに追加しました！" }
        format.json { render :show, status: :created, location: @library }
      else
        # 失敗時は検索画面に戻る
        format.html { redirect_to "/search/show/#{@library.api_str}", alert: "追加に失敗しました。" }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /libraries/1 or /libraries/1.json
  def update
    respond_to do |format|
      if @library.update(library_params)
        format.html { redirect_to @library, notice: "Library was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @library }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /libraries/1 or /libraries/1.json
  def destroy
    @library.destroy!

    respond_to do |format|
      format.html { redirect_to libraries_path, notice: "Library was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_library
      @library = Library.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def library_params
      params.expect(library: [ :user_id, :api_str, :title ])
    end
end
