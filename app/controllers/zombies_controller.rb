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
    
    if zombie.save
      render json: zombie, status: :created
    else
      render json: zombie.errors, status: :unprocessable_entity
    end
  end

  def update
    zombie = Zombie.find(params[:id])

    zombie.update(zombie_params)
    render json: zombie, status: :ok
  end

  private

  def zombie_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end
