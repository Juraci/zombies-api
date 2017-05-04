require 'rails_helper'

describe 'Zombies', type: :request do
  context 'GET /zombies' do
    it 'returns zombies in the JSON API format' do
      Zombie.create!(name: 'Ash', weapon: 'Axe')

      get '/zombies'

      expect(response.status).to eq 200
    end
  end
end
