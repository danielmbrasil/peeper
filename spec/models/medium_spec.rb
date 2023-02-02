# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Medium, type: :model do
  let(:media) { create :medium }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:medium_type) }
    it { is_expected.to validate_numericality_of(:medium_type) }
    it { is_expected.to validate_presence_of(:url) }

    context 'when validating format of url' do
      subject { build :medium, :invalid_url }

      it { is_expected.not_to be_valid }

      it 'returns a validation error message' do
        subject.validate

        expect(subject.errors[:url]).to include('is invalid')
      end
    end

    context 'when url is empty' do
      subject { build :medium, :empty_url }

      it { is_expected.not_to be_valid }

      it 'returns a validation error message' do
        subject.validate

        expect(subject.errors[:url]).to include("can't be blank")
      end
    end

    context 'when medium_type is float' do
      subject { build :medium, :float_medium_type }

      it { is_expected.not_to be_valid }

      it 'returns a validation error message' do
        subject.validate

        expect(subject.errors[:medium_type]).to include('must be an integer')
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:status) }
  end
end
