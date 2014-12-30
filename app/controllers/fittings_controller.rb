class FittingsController < ApplicationController
  def index
    @fittings = Fitting.order(:ship_name, :name)
  end

  def show
    @fitting = FittingDiff.new(Fitting.find(params[:id]))
  end

  def new
    @fitting = Fitting.new
  end

  def create
    pp fitting_params
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
