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

  describe 'GET show' do
    context 'when status exists' do
      let(:status) { create :status }

      it 'returns a status' do
        get :show, params: { id: status.id }

        expect(assigns(:status)).to eq(status)
      end

      context 'when status has media' do
        let(:status_with_media) { create :status, :with_four_media }

        it 'returns a status' do
          get :show, params: { id: status_with_media.id }

          expect(assigns(:status)).to eq(status_with_media)
        end
      end
    end

    context 'when status does not exist' do
      subject { get :show, params: { id: 1 } }

      it { is_expected.to be_not_found }

      it 'does not return a status' do
        get :show, params: { id: 1 }

        expect(assigns(:status)).to eq(nil)
      end
    end
  end
end
