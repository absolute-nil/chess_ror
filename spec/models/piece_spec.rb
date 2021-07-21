require 'rails_helper'


RSpec.describe Piece type: :model do


  let(:pawn) do
    board = Board.new(size: 8)
    Pawn.new(id: 0, x_cord: 0, y_cord: 0, face: 'NORTH', color: 'BLACK', board: board)
  end

  describe '#current_position' do
    it { expect(pawn.current_position).to eq([0, 0, 'NORTH', 'BLACK']) }
  end

  describe '#current_direction' do
    it { expect(pawn.current_direction).to eq('NORTH') }
  end

  describe '#coordinates_after_move' do
    it { expect(pawn.coordinates_after_move(2)).to eq([0, 2]) }
  end

  describe '#direction_after_shift' do
    it { expect(pawn.direction_after_shift('LEFT')).to eq('WEST') }
    it { expect(pawn.direction_after_shift('RIGHT')).to eq('EAST') }
  end

  describe '#set_position' do
    before do
      pawn.send(:set_position, 5, 5, 'WEST')
    end
    it { expect(pawn.send(:set_position, 5, 5, 'WEST')).to eq([5, 5, 'WEST']) }
  end
end
