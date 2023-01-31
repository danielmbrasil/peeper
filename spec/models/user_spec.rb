# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  describe 'validations' do
    let!(:user) { create :user }

    it { is_expected.to validate_presence_of(:handle) }
    it { is_expected.to validate_uniqueness_of(:handle) }
    it { is_expected.to validate_length_of(:handle).is_at_least(4).is_at_most(12) }

    it { is_expected.to validate_presence_of(:display_name) }
    it { is_expected.to validate_length_of(:display_name).is_at_most(30) }

    it { is_expected.to validate_presence_of(:born_at) }

    context 'when handle contains unsupported characters' do
      subject { build :user, :invalid_handle }

      it { is_expected.not_to be_valid }

      it 'returns a validation error message' do
        subject.validate

        expect(subject.errors[:handle]).to eq(['is invalid'])
      end
    end

    context 'when handle is empty' do
      subject { build :user, :empty_handle }

      it { is_expected.not_to be_valid }

      it 'returns a validation error message' do
        subject.validate

        expect(subject.errors[:handle]).to eq(["can't be blank", 'is too short (minimum is 4 characters)'])
      end
    end

    context 'when display_name is empty' do
      subject { build :user, :empty_display_name }

      it { is_expected.not_to be_valid }

      it 'returns a validation error message' do
        subject.validate

        expect(subject.errors[:display_name]).to eq(["can't be blank"])
      end
    end

    context 'when display_name is longer than 30 characters' do
      subject { build :user, :display_name_longer_than_30_chars }

      it { is_expected.not_to be_valid }

      it 'returns a validation error message' do
        subject.validate

        expect(subject.errors[:display_name]).to eq(['is too long (maximum is 30 characters)'])
      end
    end

    context 'when user is under min age' do
      subject { build :user, :under_min_age }

      it { is_expected.not_to be_valid }

      it 'returns an error message' do
        subject.validate
        expect(subject.errors[:born_at]).to eq(['must be over 13 years old'])
      end
    end

    context 'when bio is empty' do
      subject { build :user, :empty_bio }

      it { is_expected.to be_valid }
    end

    context 'when bio is longer than 300 characters' do
      subject { build :user, :bio_longer_than_300_characters }

      it 'returns a validation error message' do
        subject.validate

        expect(subject.errors[:bio]).to eq(['is too long (maximum is 300 characters)'])
      end
    end
  end
end
