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
    render_views

    context 'when body is longer than 150 characters' do
      let(:user) { create :user }
      let!(:status) { Status.create(user:, body: 'x' * 200) }

      before { get :index, format: :json }

      it 'contains full_body key' do
        parsed_body = JSON.parse(response.body)

        expect(parsed_body.first.keys).to contain_exactly('body', 'full_body', 'display_name')
      end

      it 'truncates the status body' do
        parsed_body = JSON.parse(response.body)

        response_status_body_length = parsed_body.first['body'].length

        expect(response_status_body_length).to eq(Status::BODY_INDEX_DISPLAY_LENGTH)
      end

      it 'appends ellipsis to truncated status body' do
        parsed_body = JSON.parse(response.body)

        last_3_characters = parsed_body.first['body'].chars.last(3).join

        expect(last_3_characters).to eq(Status::TRUNCATED_BODY_TERMINATOR)
      end
    end

    context 'when body is shorter than 150 characters' do
      let(:user) { create :user }
      let!(:status) { Status.create(user:, body: 'short body') }

      before { get :index, format: :json }

      it 'returns body and display_name fields' do
        parsed_body = JSON.parse(response.body)

        expect(parsed_body.first.keys).to contain_exactly('body', 'display_name')
      end
    end

    context 'when status is a reply' do
      let!(:status) { create :status }

      before do
        allow_any_instance_of(Status).to receive(:status_id).and_return(1)

        get :index, format: :json
      end

      it 'contains reply_peep key' do
        parsed_body = JSON.parse(response.body)

        expect(parsed_body.first.keys).to contain_exactly('body', 'display_name', 'reply_peep')
      end
    end
  end

  describe 'GET show in JSON' do
    render_views

    context 'when status is a reply' do
      let(:status) { create :status }

      before do
        allow_any_instance_of(Status).to receive(:status_id).and_return(1)

        get :show, params: { id: status.id }, format: :json
      end

      it 'returns HTTP 200' do
        expect(response.status).to eq(200)
      end

      it 'contains reply_peep key' do
        parsed_body = JSON.parse(response.body)

        expect(parsed_body.keys).to contain_exactly('body', 'display_name', 'reply_peep', 'media')
      end
    end

    context 'when status is not a reply' do
      let(:status) { create :status }

      before { get :show, params: { id: status.id }, format: :json }

      it 'returns HTTP 200' do
        expect(response.status).to eq(200)
      end

      it 'does not contain reply_peep key' do
        parsed_body = JSON.parse(response.body)

        expect(parsed_body.keys).to contain_exactly('body', 'display_name', 'media')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
