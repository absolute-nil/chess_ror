require 'rails_helper'


RSpec.describe Pawn type: :model do

  let(:pawn) do
    board = Board.new(size: 8)
    described_class.new(id: 0, x_cord: 0, y_cord: 0, face: 'NORTH', color: 'BLACK', board: board)
  end

  describe '#validate_position' do

    context 'if position invalid' do
      it { expect(pawn.validate_position(-1, -1)).to be_falsey }
      it { expect(pawn.validate_position(10, 10)).to be_falsey }
    end

    context 'if position valid' do
      it { expect(pawn.validate_position(1, 1)).to be_truthy }
    end

  end

  describe '#valid_fist_move?' do
    context 'if it is first move' do
      it { expect(pawn.valid_fist_move?(2)).to eq(true) }
      it { expect(pawn.valid_fist_move?(1)).to eq(true) }
    end

    context 'if not first move' do
      before(:example) do
        pawn.move(2, 'FORWARD')
      end

      it { expect(pawn.valid_fist_move?(1)).to eq(true) }
      it { expect(pawn.valid_fist_move?(2)).to eq(false) }

    end
  end

  describe '#validate' do
    context 'valid move' do
      it { expect(pawn.validate(1)).to eq([0, 1]) }
    end

    context 'not valid move' do
      it { expect(pawn.validate(7)).to eq([nil, nil]) }
    end
  end

  describe '#move' do
    context 'not a valid move' do
      it { expect(pawn.move(1, 'BACK')).to be_falsey }
    end

    context 'valid move' do
      it { expect { pawn.move(7, 'FORWARD') }.to be_truthy }
    end
  end

  describe '#change_direction' do

    context 'not a valid direction' do
      it { expect { pawn.change_direction('UP') }.to output(/can only change direction LEFT or RIGHT/).to_stdout }
    end

    context 'if valid direction provided' do
      before do
        pawn.change_direction('LEFT')
      end
      # Not Working
      # it { expect(described_class).to receive(:set_position)  }

    end

  end

end
