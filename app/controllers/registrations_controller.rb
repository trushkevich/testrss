class RegistrationsController < Devise::RegistrationsController
  before_filter :find_resource, only: [:crop, :recrop, :show]

  # overriding Devise registrations controller create action to let users upload avatars
  def create
    build_resource

    if resource.save
      resource.reprocess_avatar if resource.cropping?

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
      end

      if resource.active_for_authentication? and params[resource_name][:avatar].blank?
        respond_with resource, :location => after_sign_up_path_for(resource)
      elsif !resource.active_for_authentication? and params[resource_name][:avatar].blank?
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      else
        redirect_to user_crop_path
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # overriding Devise registrations controller update action to let users upload avatars
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    @resource = resource

    if resource.update_with_password(resource_params)
      resource.reprocess_avatar if resource.cropping?

      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true

      if params[resource_name][:avatar].blank?
        respond_with resource, :location => after_update_path_for(resource)
      else
        redirect_to user_crop_path
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # crop avatar
  def crop
  end

  # recrop avatar
  def recrop
    @resource.reprocess_pre_crop
    render :crop
  end

  # view profile page
  def show
  end


  private

  def find_resource
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    @resource = resource
  end
end


