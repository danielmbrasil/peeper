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

    describe '#follow' do
      let(:follower_user) { create :user }
      let(:followed_user) { create :user }
      let(:invalid_user) { build :user }

      context 'when a user follows another user' do
        it 'adds a follower successfully' do
          follower_user.follow(followed_user)

          expect(followed_user.followers.count).to eq(1)
        end

        it 'adds a following successfully' do
          follower_user.follow(followed_user)

          expect(follower_user.following.count).to eq(1)
        end
      end

      context 'when a user follows themselves' do
        it 'adds a follower successfully' do
          follower_user.follow(follower_user)

          expect(follower_user.followers.count).to eq(1)
        end

        it 'adds a following successfully' do
          follower_user.follow(follower_user)

          expect(follower_user.following.count).to eq(1)
        end
      end

      context 'when user is already followed' do
        it 'returns an error message' do
          follower_user.follow(followed_user)
          follower_user.follow(followed_user)

          expect(follower_user.errors[:following]).to eq(['already followed'])
        end
      end

      context 'when user follows a user that does not exist' do
        it 'returns an error message' do
          follower_user.follow(invalid_user)

          expect(follower_user.errors[:following]).to eq(['user does not exist'])
        end
      end
    end

    describe 'associations' do
      it { is_expected.to have_many(:followers).class_name('Follow') }
      it { is_expected.to have_many(:following).class_name('Follow') }
    end
  end
end
