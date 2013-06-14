class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  # POST /subscriptions/1
  # POST /subscriptions/1.json
  def create
    @channel = Channel.find(params[:channel_id])
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.html { redirect_to :back, notice: I18n.t('general.failed_to_subscribe') }
      format.json { render json: e, status: :unprocessable_entity }
    end
  else
    message = if current_user.max_channels_reached?
      I18n.t('maximum_channels_reached')
    elsif current_user.channels.include?(@channel)
      I18n.t('already_subscribed')
    end

    if (!current_user.channels.include?(@channel) && !current_user.max_channels_reached?)
      current_user.channels << @channel
      respond_to do |format|
        format.html { redirect_to @channel, notice: I18n.t('general.subscribed') }
        format.json { render json: @channel, status: :created, location: @channel }
      end
    else
      respond_to do |format|
        format.html { redirect_to @channel, notice: I18n.t('general.unable_to_subscribe') }
        format.json { render json: message, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.json
  def update
    @subscription = Subscription.by_user_channel_ids(current_user.id, params[:channel_id])

    respond_to do |format|
      if @subscription and @subscription.update_attributes(params[:subscription])
        @channel = Channel.find(params[:channel_id])
        format.html { redirect_to @subscription, notice: I18n.t('subscription_updated') }
        format.json { render json: { name: @channel.subscription_name(current_user) }, status: :ok}
      else
        format.html { render action: "edit" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @channel = Channel.find(params[:channel_id])
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.html { redirect_to :back, notice: I18n.t('general.failed_to_unsubscribe') }
      format.json { render json: e, status: :unprocessable_entity }
    end
  else
    current_user.channels.delete(@channel) if current_user.channels.include? @channel
    respond_to do |format|
      format.html { redirect_to @channel, notice: I18n.t('general.unsubscribed') }
      format.json { head :no_content }
    end
  end

end
