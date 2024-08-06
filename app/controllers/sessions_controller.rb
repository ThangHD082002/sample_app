def create
  user = find_user
  if authenticate_user user
    handle_activated_user user
  else
    handle_invalid_credentials
  end
end

private

def find_user
  User.find_by(email: params[:session][:email].downcase)
end

def authenticate_user user
  user&.authenticate(params[:session][:password])
end

def handle_activated_user user
  if user.activated?
    log_in user
    remember_me? user
    redirect_back_or user
  else
    flash[:warning] = "Account not activated. Check your email for activation."
    redirect_to root_url
  end
end

def handle_invalid_credentials
  flash.now[:danger] = t("invalid_email_password_combination")
  render :new
end

def remember_me? user
  params[:session][:remember_me] == "1" ? remember(user) : forget(user)
end
