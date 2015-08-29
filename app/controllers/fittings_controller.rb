class FittingsController < ApplicationController
  before_action :logged_in_user
  before_action :logged_in_fc_or_admin, only: [:new, :create]

  def index
    @fittings = Fitting.order(:ship_name, :name)
  end

  def show
    if logged_in_as_fc_or_admin?
      pilots = Pilot.includes(pilot_skills: :skill).where(prime: true).order(:name)
    else
      pilots = [current_user]
    end
    @fitting = FittingDiff.new(Fitting.find(params[:id]), pilots)
  end

  def new
    @fitting = Fitting.new
  end

  def create
    @fitting = Fitting.from_eft(fitting_params)
    if @fitting.save
      flash[:success] = "New fitting has been added."
      redirect_to fittings_path
    else
      flash[:error] = "Fitting has not been added!"
      render :new
    end
  end

  private

  def fitting_params
    params.require(:fitting).permit(:eft)[:eft]
  end
end
