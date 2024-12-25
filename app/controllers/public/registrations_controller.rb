class Public::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params

  protected

   def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up, keys: [:family_name, :first_name, :family_name_kana, :first_name_kana, :post_code, :tell_number, :address])
   end

end