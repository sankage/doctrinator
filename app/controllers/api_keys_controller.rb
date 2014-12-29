class ApiKeysController < ApplicationController
  def index
    @players = Player.includes(:api_keys).order(:name)
  end

  def show
    @player = Player.find(params[:player_id])
    @api_key = ApiKey.find(params[:id])

    characters = EveAPI.new(@api_key.key_id, @api_key.v_code).characters
    character_ids = @player.pilots.pluck(:character_id)
    @characters = characters.delete_if { |char|
      character_ids.include?(char.characterID)
    }
  end

  def new
    @player = Player.find(params[:player_id])
    @api_key = @player.api_keys.build
  end

  def create
    @player = Player.find(params[:player_id])
    @api_key = @player.api_keys.build(api_key_params)
    if @api_key.save
      flash[:success] = "API key has been added."
      redirect_to player_path(@player)
    else
      flash[:error] = "API key was not added!"
      render :new
    end
  end

  def import
    @player = Player.find(params[:player_id])
    @api_key = ApiKey.find(params[:id])
    selected_characters = import_params
    selected_characters.each do |character|
      id, name = character.split("|")
      @api_key.pilots.where(character_id: id, name: name).first_or_create
    end
    redirect_to player_path(@player)
  end

  def destroy
    api_key = ApiKey.find(params[:id])
    api_key.destroy
    flash[:success] = "API Key has been deleted."
    redirect_to api_keys_path
  end

  private

  def api_key_params
    params.require(:api_key).permit(:key_id, :v_code)
  end

  def import_params
    return [] unless params[:character]
    params[:character][:id_name]
  end
end
