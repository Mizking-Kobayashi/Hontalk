class PosttagsController < ApplicationController
  before_action :set_posttag, only: %i[ show edit update destroy ]

  # GET /posttags or /posttags.json
  def index
    @posttags = Posttag.all
  end

  # GET /posttags/1 or /posttags/1.json
  def show
  end

  # GET /posttags/new
  def new
    @posttag = Posttag.new
  end

  # GET /posttags/1/edit
  def edit
  end

  # POST /posttags or /posttags.json
  def create
    @posttag = Posttag.new(posttag_params)

    respond_to do |format|
      if @posttag.save
        format.html { redirect_to @posttag, notice: "Posttag was successfully created." }
        format.json { render :show, status: :created, location: @posttag }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @posttag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posttags/1 or /posttags/1.json
  def update
    respond_to do |format|
      if @posttag.update(posttag_params)
        format.html { redirect_to @posttag, notice: "Posttag was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @posttag }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @posttag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posttags/1 or /posttags/1.json
  def destroy
    @posttag.destroy!

    respond_to do |format|
      format.html { redirect_to posttags_path, notice: "Posttag was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_posttag
      @posttag = Posttag.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def posttag_params
      params.expect(posttag: [ :post_id, :tag_id ])
    end
end
