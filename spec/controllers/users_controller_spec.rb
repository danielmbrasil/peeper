# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe UsersController, type: :controller do
  describe 'GET index in JSON' do
    render_views

    context 'when there are users' do
      let!(:users) { create_list(:user, 5) }

      before { get :index, format: :json }

      it 'returns HTTP 200' do
        expect(response.status).to eq(200)
      end

      it 'contains display_name key' do
        parsed_body = JSON.parse(response.body)

        expect(parsed_body.first.keys).to contain_exactly('display_name')
      end

      it 'returns correct display_name' do
        parsed_body = JSON.parse(response.body)

        expect(parsed_body.first['display_name']).to eq(users.first.display_name)
      end
    end

    context 'when there is no user' do
      before { get :index, format: :json }

      it 'returns HTTP 200' do
        expect(response.status).to eq(200)
      end

      it 'returns empty body' do
        parsed_body = JSON.parse(response.body)

        expect(parsed_body).to eq([])
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
