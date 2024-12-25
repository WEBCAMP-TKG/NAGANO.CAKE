class Public::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    customers_mypage_path
  end

  def after_sign_out_path_for(resource)
    about_path
  end

  def reject_customer
   @customer = Customer.find_by(email: params[:customer][:email])
    if @customer
     if @customer.valid_password?(params[:customer][:password]) && (@customer.active_for_authentication? == true)
     else
      flash[:error] = "退会済みです。再度新規登録をしてご利用ください。"
      redirect_to new_customer_registration_path
     end
    else
      flash[:error] = "該当するユーザーが見つかりません。"
    end
  end
end