# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Board type: :model do

  let(:board) { described_class.new(size: 8) }
  describe '#move_within_bounds?' do

    context 'if not valid coordinates' do
      it { expect(board.move_within_bounds?(-1,-1)).to be_falsey }
      it { expect(board.move_within_bounds?(0, 9)).to be_falsey }
    end

    context 'if valid coordinates' do
      it { expect(board.move_within_bounds?(7,7)).to be_truthy }
    end

  end
end
