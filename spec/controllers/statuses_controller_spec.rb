# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatusesController, type: :controller do
  describe 'GET index' do
    it 'returns a successful response' do
      get :index

      expect(response).to be_successful
    end

    it 'returns a list of statuses' do
      status_list = create_list(:status, 5)

      get :index

      expect(assigns(:statuses)).to eq(status_list)
    end

    it 'renders the index view' do
      get :index

      expect(response).to render_template('index')
    end
  end
end
