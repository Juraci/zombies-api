class ZombiesController < ApplicationController
  def index
    zombies = Zombie.all
    if params[:weapon]
      zombies = zombies.where(weapon: params[:weapon])
    end
    render json: zombies, status: :ok
  end
end
