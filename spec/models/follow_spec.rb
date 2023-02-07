# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:follow) { create :follow }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:follower_id) }
    it { is_expected.to validate_presence_of(:followed_id) }

    context 'when follower_id is nil' do
      subject { build :follow, :no_follower_id }

      it { is_expected.not_to be_valid }

      it 'returns a validation error message' do
        subject.validate

        expect(subject.errors[:follower_id]).to eq(["can't be blank"])
      end
    end

    context 'when followed_id is nil' do
      subject { build :follow, :no_followed_id }

      it { is_expected.not_to be_valid }

      it 'returns a validation error message' do
        subject.validate

        expect(subject.errors[:followed_id]).to eq(["can't be blank"])
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:follower).required }
    it { is_expected.to belong_to(:followed).required }
  end
end
