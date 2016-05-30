module SessionsHelper
  def must_be_logged_in
    redirect_to new_session_url unless signed_in?
  end
  
  def signed_in?
    !!current_user
  end
  
  def current_user
    return nil if session[:token] == nil
    @current_user ||= User.find_by_session_token(session[:token])
  end
  
  def sign_in!(user)
    user.generate_session_token!
    session[:token] = user.session_token
  end
  
  def sign_out!(user)
    user.session_token = nil
    user.save!
    session[:token] = nil
  end
end
