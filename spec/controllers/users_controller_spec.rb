# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe UsersController, type: :controller do
  describe 'GET #index in JSON' do
    render_views

    context 'when there are users' do
      let!(:users) { create_list(:user, 10) }

      let(:expected_response_body) do
        users.map do |user|
          { display_name: user.display_name }.with_indifferent_access
        end
      end

      it 'returns HTTP status OK' do
        get :index, format: :json

        expect(response).to have_http_status(:ok)
      end

      it 'returns users correctly' do
        get :index, format: :json

        parsed_body = JSON.parse(response.body)

        expect(parsed_body).to eq(expected_response_body)
      end
    end

    context 'when there is no user' do
      it 'returns HTTP status OK' do
        get :index, format: :json

        expect(response).to have_http_status(:ok)
      end

      it 'returns empty body' do
        get :index, format: :json

        parsed_body = JSON.parse(response.body)

        expect(parsed_body).to eq([])
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
