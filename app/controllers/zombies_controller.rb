class ZombiesController < ApplicationController
  def index
    zombies = Zombie.all
    if params[:weapon]
      zombies = zombies.where(weapon: params[:weapon])
    end
    render json: zombies, status: :ok
  end

  def show
    render json: Zombie.find(params[:id]), status: :ok
  end

  def create
    zombie = Zombie.new(zombie_params)
    zombie.save
    render json: zombie, status: :created
  end

  private

  def zombie_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end
