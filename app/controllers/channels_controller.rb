class ChannelsController < ApplicationController
  before_filter :require_user, only: [:subscribed]

  # GET /channels
  # GET /channels.json
  def index
    @channels = Channel.order("id DESC").page(params[:page]).per(10)

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.json { render json: @channels }
    end
  end

  # POST /channels
  # POST /channels.json
  # POST /channels.js
  def create
    @channel = Channel.new(params[:channel])

    respond_to do |format|
      user = user_signed_in? ? current_user : nil
      if @channel.save
        # if channel is created it means that it is newly added channel and we need to
        # parse channel name and articles
        data = Article.create_by_channel(@channel)
        # subscribe a user for it if it is possible
        if user && !current_user.max_channels_reached?
          current_user.channels << @channel 
          data[:subscribed] = true
        else
          data[:subscribed] = false
        end
      else
        # if a channel is not created it means that it is either a not valid feed (ie search string)
        # or the channel already exists
        data = Channel.subscribe_or_find(user, params[:channel][:url])
      end

      format.json { render json: data, status: :ok, location: @channel }

      if data.has_key? :articles
        format.html { render partial: 'articles/list', locals: { data: data } }
      elsif data.has_key? :channels
        format.html { render partial: 'channels/list', locals: { channels: Kaminari.paginate_array(data[:channels]).page(1).per(Channel::PER_SEARCH_PAGE), search: params[:channel][:url] } }
      end

    end
  end


  # GET /channels/subscribed
  # GET /channels/subscribed.json
  def subscribed
    @channels = current_user.channels.order("id DESC").page(params[:page]).per(10)

    render_params = [:index]
    render_params << {layout: false} if request.xhr?

    render *render_params
  end

  # GET /channels/1/articles
  # GET /channels/1/articles.json
  def articles
    @channel = Channel.find(params[:id])
    @articles = @channel.articles.order("published_at DESC").page(params[:page]).per(5)

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.json { render json: @articles }
    end
  end


end
