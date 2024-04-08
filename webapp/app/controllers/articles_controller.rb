class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  # GET /articles or /articles.json
  def index
 #   @articles = Article.all.sort_by(&:published_date) # .reverse # DESC
    #@articles = Article.select(&:published_date).sort_by(&:published_date).last(50).reverse # DESC
    if params['macro_region']
      @region = params['macro_region']
      @articles = Rails.cache.fetch("latest_n_articles_cached_{ @region }", expires_in: 10.minute) {
        Article.where(macro_region: @region).select(&:published_date).sort_by(&:published_date).last(50).reverse # DESC
      }
      @article_total_count = Rails.cache.fetch("total_count_for_{ @region }", expires_in: 10.minute) {
        Article.where(macro_region: @region).all.count
      }
    else
      @articles = @cached_latest_n_articles
      @article_total_count = Article.all.count
    end
  end

  # GET /articles/1 or /articles/1.json
  def show
    @categories = @article.categories
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy!

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :summary, :content, :author, :link, :published_date, :image_url, :feed_url, :guid, :hidden_blurb, :language, :active, :ricc_internal_notes, :ricc_source)
    end
end
