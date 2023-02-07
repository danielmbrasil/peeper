# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatusesController, type: :controller do
  describe 'GET index' do
    context 'when there are statuses available' do
      let(:status_list) { create_list(:status, 5) }

      it 'returns a successful response' do
        get :index

        expect(response).to be_successful
      end

      it 'returns a list of statuses' do
        get :index

        expect(assigns(:statuses)).to eq(status_list)
      end
    end

    context 'when there is no status available' do
      it 'returns a successful response' do
        get :index

        expect(response).to be_successful
      end

      it 'returns an empty list of statuses' do
        get :index

        expect(assigns(:statuses)).to eq([])
      end
    end
  end
end
