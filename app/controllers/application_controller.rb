class ApplicationController < ActionController::Base
  protect_from_forgery

  def routing_error
    flash[:alert] = I18n.t('general.page_not_found')
    redirect_to root_url
  end


  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.json  { head :not_found }
    end
  end



  def after_sign_in_path_for(resource)
    root_path
  end

  def require_user
    unless user_signed_in?
      flash[:alert] = I18n.t('text.must_be_signed_in')
      redirect_to new_user_session_path
    end
  end

  def authenticate_admin_user!
    if user_signed_in? and !current_user.is_admin
      flash[:alert] = I18n.t('text.must_be_signed_in_admin')
      redirect_to root_path
    elsif !user_signed_in?
      flash[:alert] = I18n.t('text.must_be_signed_in_admin')
      redirect_to new_user_session_path
    end
  end

  def render_pagination(items, controller, action, partial = 'shared/_pagination.html.slim')
    render_to_string 'shared/_pagination.html.slim', layout: false, locals: {items: items, controller: controller, action: action}
  end

end
