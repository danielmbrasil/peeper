# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
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

  describe 'GET index in JSON' do
    let(:parsed_body) { JSON.parse(response.body) }

    render_views

    context 'when body is longer than 150 characters' do
      let(:user) { create :user }
      let!(:status) { Status.create(user:, body: 'x' * 200) }
      let(:expected_keys) { %w[body full_body display_name] }

      it 'contains full_body key' do
        get :index, format: :json

        expect(parsed_body.first.keys).to eq(expected_keys)
      end

      it 'truncates the status body' do
        get :index, format: :json

        response_status_body_length = parsed_body.first['body'].length

        expect(response_status_body_length).to eq(Status::BODY_INDEX_DISPLAY_LENGTH)
      end

      it 'appends ellipsis to truncated status body' do
        get :index, format: :json

        status_body = parsed_body.first['body']

        expect(status_body.ends_with?(Status::TRUNCATED_BODY_TERMINATOR)).to eq(true)
      end
    end

    context 'when body is shorter than 150 characters' do
      let(:user) { create :user }
      let!(:status) { Status.create(user:, body: 'short body') }
      let(:expected_keys) { %w[body display_name] }

      it 'returns body and display_name fields' do
        get :index, format: :json

        expect(parsed_body.first.keys).to eq(expected_keys)
      end
    end

    context 'when status is a reply' do
      let!(:status) { create :status }
      let(:expected_keys) { %w[body display_name reply_peep] }

      before { allow_any_instance_of(Status).to receive(:parent_id).and_return(1) }

      it 'contains reply_peep key' do
        get :index, format: :json

        expect(parsed_body.first.keys).to eq(expected_keys)
      end
    end
  end

  describe 'GET show in JSON' do
    render_views

    context 'when status is a reply' do
      let(:status) { create :status }
      let(:expected_keys) { %w[body display_name reply_peep media] }
      let(:parsed_body) { JSON.parse(response.body) }
      let(:expected_response_body) do
        {
          body: status.body,
          display_name: status.user.display_name,
          reply_peep: true,
          media: status.media.size
        }.with_indifferent_access
      end

      before { allow_any_instance_of(Status).to receive(:parent_id).and_return(1) }

      it 'returns HTTP status OK' do
        get :show, params: { id: status.id }, format: :json

        expect(response).to have_http_status(:ok)
      end

      it 'contains reply_peep key' do
        get :show, params: { id: status.id }, format: :json

        expect(parsed_body.keys).to eq(expected_keys)
      end

      it 'returns response body correctly' do
        get :show, params: { id: status.id }, format: :json

        expect(parsed_body).to eq(expected_response_body)
      end
    end

    context 'when status is not a reply' do
      let(:status) { create :status }
      let(:expected_keys) { %w[body display_name media] }
      let(:parsed_body) { JSON.parse(response.body) }
      let(:expected_response_body) do
        {
          body: status.body,
          display_name: status.user.display_name,
          media: status.media.size
        }.with_indifferent_access
      end

      it 'returns HTTP status OK' do
        get :show, params: { id: status.id }, format: :json

        expect(response).to have_http_status(:ok)
      end

      it 'does not contain reply_peep key' do
        get :show, params: { id: status.id }, format: :json

        expect(parsed_body.keys).to eq(expected_keys)
      end

      it 'returns response body correctly' do
        get :show, params: { id: status.id }, format: :json

        expect(parsed_body).to eq(expected_response_body)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
