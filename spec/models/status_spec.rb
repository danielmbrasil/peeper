# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Status, type: :model do
  let(:status) { create :status }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_length_of(:body).is_at_least(1) }
    it { is_expected.to validate_length_of(:body).is_at_most(300) }

    context 'when status is a reply' do
      subject { build :status, :reply }

      it { is_expected.to be_valid }
    end

    context 'when body is empty' do
      subject { build :status, :empty_body }

      it { is_expected.not_to be_valid }

      it 'returns an error message' do
        subject.validate

        expect(subject.errors[:body]).to eq(["can't be blank", 'is too short (minimum is 1 character)'])
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:replies) }
  end
end