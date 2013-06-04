class FavouritesController < ApplicationController

  # POST /subscriptions/1
  # POST /subscriptions/1.json
  def add_to_favourites
    @favourite = Kernel.const_get(params[:favouritable_type].capitalize).find(params[:favouritable_id])
  rescue NameError, ActiveRecord::RecordNotFound => e
    File.open('/tmp/logger.txt', "a") { |file|  file.puts e.inspect }
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Failed to add to favourites.' }
      format.json { render json: e, status: :unprocessable_entity }
    end
  else
    current_user.public_send(:"favourite_#{params[:favouritable_type]}s") << @favourite unless current_user.public_send(:"favourite_#{params[:favouritable_type]}s").include? @favourite
    respond_to do |format|
      format.html { redirect_to @favourite, notice: 'Successfully added to favourites.' }
      format.json { render json: @favourite, status: :created, location: @favourite }
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def remove_from_favourites
    @favourite = Kernel.const_get(params[:favouritable_type].capitalize).find(params[:favouritable_id])
  rescue NameError, ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Failed to remove from favourites.' }
      format.json { render json: e, status: :unprocessable_entity }
    end
  else
    current_user.public_send(:"favourite_#{params[:favouritable_type]}s").delete(@favourite) if current_user.public_send(:"favourite_#{params[:favouritable_type]}s").include? @favourite
    respond_to do |format|
      format.html { redirect_to @favourite, notice: 'Successfully removed from favourites.' }
      format.json { head :no_content }
    end
  end
end
