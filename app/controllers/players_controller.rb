class PlayersController < ApplicationController
  def index
    @players = Player.includes(:pilots).order(:name)
  end

  def show
    @player = Player.find(params[:id])
    @pilots = @player.pilots
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    if @player.save
      flash[:success] = "New player has been added."
      redirect_to players_path
    else
      flash[:error] = "Player has not been added!"
      render :new
    end
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end
end
