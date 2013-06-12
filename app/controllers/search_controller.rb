class SearchController < ApplicationController

  def index
    if request.xhr?
      search = params[:search]
      channels = Kaminari.paginate_array(Channel.find_by_url_or_name(search)).page(1).per(Channel::PER_SEARCH_PAGE)
      articles = Kaminari.paginate_array(Article.find_by_title_or_description(search)).page(1).per(Article::PER_SEARCH_PAGE)

      data = {
        channels: channels.blank? ? '' : (render_to_string channels),
        articles: articles.blank? ? '' : (render_to_string articles),
        channels_pagination: channels.blank? ? '' : render_pagination(channels, 'search', 'channels_page'),
        articles_pagination: articles.blank? ? '' : render_pagination(articles, 'search', 'articles_page'),
      }

      respond_to do |format|
        format.json { render json: data, status: :ok }
      end
    end
  end


  def channels_page
    if request.xhr?
      search = params[:search]
      channels = Kaminari.paginate_array(Channel.find_by_url_or_name(search)).page(params[:page]).per(Channel::PER_SEARCH_PAGE)

      data = {
        channels: (render_to_string channels),
        channels_pagination: render_pagination(channels, 'search', 'channels_page'),
      }

      respond_to do |format|
        format.html { render channels, status: :ok }
        format.json { render json: data, status: :ok }
      end
    end
  end


  def articles_page
    if request.xhr?
      search = params[:search]
      articles = Kaminari.paginate_array(Article.find_by_title_or_description(search)).page(params[:page]).per(Article::PER_SEARCH_PAGE)

      data = {
        articles: (render_to_string articles),
        articles_pagination: render_pagination(articles, 'search', 'articles_page'),
      }

      respond_to do |format|
        format.json { render json: data, status: :ok }
      end
    end
  end

end
