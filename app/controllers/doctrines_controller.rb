class DoctrinesController < ApplicationController
  def index
    @doctrines = Doctrine.order(:name)
  end

  def show
    @doctrine = DoctrineDiff.new(Doctrine.includes(:fittings).find(params[:id]))
  end

  def new
    @doctrine = Doctrine.new
  end

  def create
    @doctrine = Doctrine.new(doctrine_params)
    if @doctrine.save
      flash[:success] = "Doctrine has been created."
      redirect_to doctrines_path
    else
      flash[:error] = "Doctrine was not added!"
      render :new
    end
  end

  def edit
    @doctrine = Doctrine.includes(:fittings).find(params[:id])
  end

  def update
    @doctrine = Doctrine.includes(:fittings).find(params[:id])
    if @doctrine.update(doctrine_params)
      flash[:success] = "Doctrine has been updated."
      redirect_to doctrine_path(@doctrine)
    else
      flash[:error] = "Doctrine was not updated!"
      render :edit
    end
  end

  private

  def doctrine_params
    params.require(:doctrine).permit(:name, fitting_ids: [])
  end
end
