# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Statuses', type: :request do
  let(:user) { create :user }
  let(:status) { create :status }

  describe 'GET /index' do
    subject { get '/statuses' }

    it { is_expected.to eq(200) }

    it { is_expected.to render_template('index') }
  end

  describe 'GET /show' do
    subject { get "/status/#{status.id}" }

    it { is_expected.to eq(200) }
    it { is_expected.to render_template('show') }

    context 'when status is not found' do
      subject { get '/status/foo' }

      it { is_expected.to eq(404) }
    end
  end

  describe 'GET /new' do
    subject { get '/status/new' }

    it { is_expected.to eq(200) }
    it { is_expected.to render_template('new') }
  end

  describe 'GET /new/:parent_id' do
    subject { get "/status/new/#{status.id}" }

    it { is_expected.to eq(200) }
    it { is_expected.to render_template('new') }
  end

  describe 'POST /statuses' do
    context 'when creating a valid status' do
      let(:params) { { user_id: user.id, body: 'status[:body' } }

      it 'creates a status and redirects to show view' do
        post '/statuses', params: { status: params }

        expect(response).to redirect_to(assigns(:status))
        follow_redirect!

        expect(response).to render_template('show')
        expect(response.status).to eq(200)
      end

      context 'when creating a valid status with media' do
        let(:params) { { user_id: user.id, body: 'body', media: build_list(:medium, 3) } }

        it 'creates a status and redirects to show view' do
          post '/statuses', params: { status: params }

          expect(response).to redirect_to(assigns(:status))
          follow_redirect!

          expect(response).to render_template('show')
          expect(response.status).to eq(200)
        end
      end

      context 'when replying a status' do
        let(:params) { { parent_id: status.id, user_id: user.id, body: 'body' } }

        it 'creates a reply and loads show view' do
          post '/statuses', params: { status: params }

          expect(response).to redirect_to(assigns(:status))
          follow_redirect!

          expect(response).to render_template('show')
          expect(response.status).to eq(200)
        end
      end
    end

    context 'when creating an invalid status' do
      let(:params) { { user_id: user.id, body: '' } }

      it 'returns HTTP 422 and reloads the new view' do
        post '/statuses', params: { status: params }

        expect(response.status).to eq(422)
        expect(response).to render_template('new')
      end
    end
  end

  describe 'GET /status/:id/edit' do
    context 'when status exists' do
      subject { get "/status/#{status.id}/edit" }

      it { is_expected.to eq(200) }

      it { is_expected.to render_template('edit') }
    end

    context 'when status does not exist' do
      let(:status) { build :status }

      subject { get "/status/#{status.id}/edit" }

      it { is_expected.to eq(404) }
    end
  end

  describe 'PATCH /status/:id' do
    context 'when update is valid' do
      let(:params) { { body: 'a new body' } }

      it 'updates the existing status and redirects to show view' do
        patch "/status/#{status.id}", params: { status: params }

        expect(response).to redirect_to(assigns(:status))
        follow_redirect!

        expect(response).to render_template('show')
        expect(response.status).to eq(200)
      end
    end

    context 'when update is invalid' do
      let(:params) { { body: '' } }

      it 'returns HTTP 422 and reloads the edit view' do
        patch "/status/#{status.id}", params: { status: params }

        expect(response.status).to eq(422)
        expect(response).to render_template('edit')
      end
    end

    context 'when status does not exist' do
      let(:params) { { body: 'body' } }

      it 'returns HTTP 404' do
        patch '/status/1', params: { status: params }

        expect(response.status).to eq(404)
      end
    end
  end

  describe 'DELETE /status/:id' do
    context 'when status exists' do
      it 'deletes status and redirects to index view' do
        delete "/status/#{status.id}"

        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        follow_redirect!

        expect(response.status).to eq(200)
        expect(response).to render_template('index')
      end
    end

    context 'when status is not found' do
      it 'returns HTTP 404' do
        delete '/status/1'

        expect(response.status).to eq(404)
      end
    end

    context 'when status has media' do
      let(:status_with_media) { create :status, :with_four_media }

      it 'deletes status and redirects to index view' do
        delete "/status/#{status_with_media.id}"

        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        follow_redirect!

        expect(response.status).to eq(200)
        expect(response).to render_template('index')
      end
    end

    context 'when status has replies' do
      let(:status_with_reply) { status.replies.create(body: 'reply', user_id: status.user_id) }

      it 'deletes status and redirects to index view' do
        delete "/status/#{status_with_reply.id}"

        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        follow_redirect!

        expect(response.status).to eq(200)
        expect(response).to render_template('index')
      end
    end
  end
end
