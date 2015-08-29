class SessionsController < ApplicationController
  def new
    redirect_to '/auth/evesso'
  end

  def create
    auth = request.env['omniauth.auth']
    eveapi  = EAAL::API.new(nil, nil, 'eve')
    character_info = eveapi.CharacterInfo(characterID: auth[:info].character_id)
    if character_info.corporation != 'POS Party'
      flash[:error] = "You are not a member of our corporation."
    else
      pilot = Pilot.find_by(character_id: auth['uid'].to_s)
      if pilot.nil?
        flash[:alert] = "You are not registered."
      else
        log_in pilot
      end
    end

    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out!"
  end
end
