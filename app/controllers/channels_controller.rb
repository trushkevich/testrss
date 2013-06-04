class ChannelsController < ApplicationController
  # GET /channels
  # GET /channels.json
  def index
    @channels = Channel.order("id DESC").page(params[:page]).per(10)

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.json { render json: @channels }
    end
  end

  # GET /channels/1
  # GET /channels/1.json
  def show
    @channel = Channel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @channel }
    end
  end

  # GET /channels/new
  # GET /channels/new.json
  def new
    @channel = Channel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @channel }
    end
  end

  # GET /channels/1/edit
  def edit
    @channel = Channel.find(params[:id])
  end

  # POST /channels
  # POST /channels.json
  # POST /channels.js
  def create
    @channel = Channel.new(params[:channel])

    respond_to do |format|
      if @channel.save
        # if channel is created it means that it is newly added channel and we need to
        # subscribe a user for it and parse channel name and articles
        current_user.channels << @channel
        data = @channel.create_articles
      else
        # if a channel is not created it means that it is either a not valid feed (ie search string)
        # or the channel already exists
        data = Channel.subscribe_or_find(current_user, params[:channel][:url])
      end

      format.json { render json: data, status: :ok, location: @channel }

      if data.has_key? :articles
        format.html { render :partial => 'articles/list', :locals => { :articles => data[:articles] } }
      elsif data.has_key? :channels
        format.html { render :partial => 'channels/list', :locals => { :channels => data[:channels] } }
      end

    end
  end


  # PUT /channels/1
  # PUT /channels/1.json
  def update
    @channel = Channel.find(params[:id])

    respond_to do |format|
      if @channel.update_attributes(params[:channel])
        format.html { redirect_to @channel, notice: 'Channel was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channels/1
  # DELETE /channels/1.json
  def destroy
    @channel = Channel.find(params[:id])
    @channel.destroy

    respond_to do |format|
      format.html { redirect_to channels_url }
      format.json { head :no_content }
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
