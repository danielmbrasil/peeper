# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatusesController, type: :controller do
  describe 'GET index' do
    subject { get :index }

    context 'when there are statuses available' do
      let(:status_list) { create_list(:status, 5) }

      it { is_expected.to be_successful }

      it 'returns a list of statuses' do
        get :index

        expect(assigns(:statuses)).to eq(status_list)
      end
    end

    context 'when there is no status available' do
      it { is_expected.to be_successful }

      it 'returns an empty list of statuses' do
        get :index

        expect(assigns(:statuses)).to eq([])
      end
    end
  end
end
