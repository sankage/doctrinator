module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
    @current_user = user
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= Pilot.find_by(id: session[:user_id])
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def logged_in_as_admin?
    current_user.admin?
  end

  def logged_in_as_fc?
    current_user.fc?
  end

  def logged_in_as_fc_or_admin?
    logged_in_as_fc? || logged_in_as_admin?
  end
end
