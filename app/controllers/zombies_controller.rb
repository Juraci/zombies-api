class ZombiesController < ApplicationController
  def index
    render json: Zombie.all, status: :ok
  end
end
