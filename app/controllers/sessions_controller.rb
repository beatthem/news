class SessionsController < Devise::SessionsController
  def create
    user_authed = warden.authenticate?(auth_options)
    user = User.find(:first, :conditions => [ "email = ?", params['user']['email']])
    if user_authed or user  # Пользователь найден
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
    else  # новый пользователь - регистрируем
      build_resource
      sign_in(resource_name, resource)
    end
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    respond_with resource, :location => after_sign_in_path_for(resource)
  end
end
