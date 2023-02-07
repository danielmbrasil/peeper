# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Statuses', type: :request do
  describe 'GET /index' do
    it 'returns HTTP success code' do
      get '/statuses'

      expect(response.status).to eq(200)
    end

    it 'renders the index view' do
      get '/statuses'

      expect(response).to render_template('index')
    end
  end
end
