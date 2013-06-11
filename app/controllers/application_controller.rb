class ApplicationController < ActionController::Base
  protect_from_forgery

  def routing_error
    flash[:alert] = "Requested page not found."
    redirect_to root_url
  end


  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.json  { head :not_found }
    end
  end


  private

  def render_pagination(items, controller, action, partial = 'shared/_pagination.html.slim')
    render_to_string 'shared/_pagination.html.slim', layout: false, locals: {items: items, controller: controller, action: action}
  end

end
