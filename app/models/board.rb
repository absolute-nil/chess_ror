# frozen_string_literal: true

class Board
  include ActiveModel::Model
  attr_accessor :origin_x, :origin_y, :size, :my_piece, :pieces

  def initialize(attributes)
    super
    @origin_x = 0
    @origin_y = 0
    @size = size || 0
    @my_piece = my_piece || nil
    @pieces = pieces || 0
  end

  def move_within_bounds?(x, y)
    return false if (x < @origin_x) || (x >= (@origin_x + @size)) || (y < @origin_y) || (y >= (@origin_y + @size))

    true
  end

end

