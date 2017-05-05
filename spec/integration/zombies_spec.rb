require 'rails_helper'

describe 'Zombies', type: :request do
  before(:example) do
    Zombie.delete_all
  end

  context 'GET /zombies' do
    it 'returns zombies in the JSON API format' do
      Zombie.create!(name: 'Ash', weapon: 'Axe')

      get '/zombies'

      expect(response.status).to eq 200
    end
  end

  context 'GET /zombies?weapon=Axe' do
    it 'returns only the zombies that have axes' do
      Zombie.create!(name: 'Ash', weapon: 'Axe')
      Zombie.create!(name: 'Ana', weapon: 'Shotgun')

      get '/zombies?weapon=Axe'

      expect(response.status).to eq 200
      zombies = JSON.parse(response.body, symbolize_names: true)
      expect(zombies[:data].length).to eq 1
      expect(zombies[:data].first[:attributes][:name]).to eq 'Ash'
    end
  end
end
