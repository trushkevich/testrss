class ArticlesController < ApplicationController
  before_filter :require_user, only: [:favourite, :add_comment]

  # GET /articles
  # GET /articles.json
  # root_url points here
  def index
    @articles = Article.order('published_at DESC').page(params[:page]).per(5)

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.json { render json: @articles }
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
        format.html { redirect_to @article, notice: I18n.t('general.comment_added') }
        rendered_comments = ''
        @article.comments.each do |comment|
          rendered_comments << render_to_string('articles/_comment', :layout => false, :locals => {comment: comment}, :formats => [:html])
        end
        format.json { render json: { comments: rendered_comments, count: @article.comments.count } }
      else
        format.html { render action: "edit" }
        format.json { render json: false, status: :unprocessable_entity }
      end
    end
  end

end