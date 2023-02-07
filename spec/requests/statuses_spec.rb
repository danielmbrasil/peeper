# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Statuses', type: :request do
  describe 'GET /index' do
    subject { get '/statuses' }

    it { is_expected.to eq(200) }

    it { is_expected.to render_template('index') }
  end

  describe 'GET /show' do
    let(:status) { create :status }

    subject { get "/status/#{status.id}" }

    it { is_expected.to eq(200) }
    it { is_expected.to render_template('show') }

    context 'when status is not found' do
      subject { get '/status/1' }

      it { is_expected.to eq(404) }
    end
  end
end
