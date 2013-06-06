class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.order('published_at DESC').page(params[:page]).per(5)

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.json { render json: @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end

  # GET /articles/favourite
  # GET /articles/favourite.json
  def favourite
    @articles = current_user.favourite_articles.order('published_at DESC').page(params[:page]).per(5)

    render_params = [:index]
    render_params << {layout: false} if request.xhr?

    render *render_params
  end

  # GET /articles/1/comments
  # GET /articles/1/comments.json
  def comments
    @article = Article.find(params[:id])
    @comments = @article.comments

    respond_to do |format|
      format.html 
      format.json { render json: @comments, status: :ok }
    end
  end

  # POST /articles/1/add_comment
  # POST /articles/1/add_comment.json
  def add_comment
    @article = Article.find(params[:id])
    
    respond_to do |format|
      if comment = @article.comments.create(params[:comment].merge(user_id: current_user.id))
        format.html { redirect_to @article, notice: 'Comment successfully added.' }
        rendered_comments = ''
        @article.comments.each do |comment|
          rendered_comments << render_to_string('articles/_comment', :layout => false, :locals => {comment: comment})
        end
        format.json { render json: { comments: rendered_comments, count: @article.comments.count } }
      else
        format.html { render action: "edit" }
        format.json { render json: false, status: :unprocessable_entity }
      end
    end
  end

end