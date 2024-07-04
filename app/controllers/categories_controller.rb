class CategoriesController < ApplicationController
  #before_action :set_category, only: %i[ show edit update destroy ]
  before_action :header_menu

  # GET /categories or /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1 or /categories/1.json
  def show
    category
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    category
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)
    
    if @category.save
      redirect_to category_url(@category), notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    if category.update(category_params)
      redirect_to category_url(@category), notice: "Category was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    category.destroy
    
    redirect_to categories_url, notice: "Category was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def category
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:nombre)
    end

    def header_menu
        @header_menu = true
    end
end
