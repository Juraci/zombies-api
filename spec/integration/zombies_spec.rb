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
      expect(response.content_type).to eq 'application/vnd.api+json'
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

  context 'GET /zombies/:id' do
    it 'returns the zombie by id' do
      zombie = Zombie.create!(name: 'Ash', weapon: 'Axe')

      get "/zombies/#{zombie.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/vnd.api+json'
      zombie_parsed = JSON.parse(response.body, symbolize_names: true)
      expect(zombie_parsed[:data][:attributes][:name]).to eq 'Ash'
    end
  end

  context 'POST /zombies' do
    it 'creates a zombie' do
      new_zombie = {
        data: {
          type: 'zombies',
          attributes: {
            name: 'Johana',
            weapon: 'machinegun'
          }
        }
      }

      headers = { 'Content-Type' => 'application/vnd.api+json' }

      post('/zombies', params: new_zombie, headers: headers, as: :json)

      expect(response.status).to eq 201
      zombie_parsed = JSON.parse(response.body, symbolize_names: true)
      expect(zombie_parsed[:data][:attributes][:name]).to eq 'Johana'
    end

    context 'when the name is not passed' do
      it 'returns 422' do
        new_zombie = {
          data: {
            type: 'zombies',
            attributes: {
              name: nil,
              weapon: 'machinegun'
            }
          }
        }

        headers = { 'Content-Type' => 'application/vnd.api+json' }

        post('/zombies', params: new_zombie, headers: headers, as: :json)
        expect(response.status).to eq 422
      end
    end

    context 'PATCH /zombies' do
      it 'updates a zombie' do
        updated_zombie = {
          data: {
            type: 'zombies',
            attributes: {
              name: 'Ash',
              weapon: 'machinegun'
            }
          }
        }

        zombie = Zombie.create!(name: 'Ash', weapon: 'Axe')

        patch("/zombies/#{zombie.id}", params: updated_zombie, headers: headers, as: :json)

        expect(response.status).to eq 200
        expect(zombie.reload.weapon).to eq 'machinegun'
      end
    end
  end
end
