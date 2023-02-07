# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Statuses', type: :request do
  describe 'GET /index' do
    subject { get '/statuses' }

    it { is_expected.to eq(200) }

    it { is_expected.to render_template('index') }
  end
end
