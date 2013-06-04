class SubscriptionsController < ApplicationController

  # POST /subscriptions/1
  # POST /subscriptions/1.json
  def create
    @channel = Channel.find(params[:channel_id])
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Failed to subscribe.' }
      format.json { render json: e, status: :unprocessable_entity }
    end
  else
    current_user.channels << @channel if (!current_user.channels.include? @channel && !current_user.max_channels_reached?)
    respond_to do |format|
      format.html { redirect_to @channel, notice: 'Successfully subscribed.' }
      format.json { render json: @channel, status: :created, location: @channel }
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.json
  def update
    @subscription = Subscription.find(params[:channel_id])

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to @subscription, notice: 'Subscription was successfully updated.' }
        format.json { head :no_content }
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
      format.html { redirect_to :back, notice: 'Failed to unsubscribe.' }
      format.json { render json: e, status: :unprocessable_entity }
    end
  else
    current_user.channels.delete(@channel) if current_user.channels.include? @channel
    respond_to do |format|
      format.html { redirect_to @channel, notice: 'Successfully unsubscribed.' }
      format.json { head :no_content }
    end
  end

end
