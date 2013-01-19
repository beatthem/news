class SessionsController < Devise::SessionsController
  def create
    puts '========================================'
    self.resource = warden.authenticate?(auth_options)
    puts '++++++++++++++++++++++++++++++++++++++++'
    puts self.resource
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    if resource
      sign_in(resource_name, resource)
    else
      build_resource
      sign_in(resource_name, resource)
    end
    respond_with resource, :location => after_sign_in_path_for(resource)
  end
end
