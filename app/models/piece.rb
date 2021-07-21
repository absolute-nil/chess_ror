class Piece
  include ActiveModel::Model
  attr_accessor :color, :x_cord, :y_cord, :face, :id, :board

  @@instance_collector = []

  def self.get_instance_by_id(id)
    @@instance_collector.select { |piece| piece.id == id }
  end

  # def is_overlapping?(x_cord, y_cord)
  #  Can implement it later
  # end
  def current_position
    [x_cord, y_cord, face, color]
  end

  def current_direction
    face
  end

  def coordinates_after_move(units)
    # only supporting straight moves for now
    return [x_cord, y_cord + units] if face == 'NORTH'

    return [x_cord, y_cord - units] if face == 'SOUTH'

    return [x_cord + units, y_cord] if face == 'EAST'

    return [x_cord - units, y_cord] if face == 'WEST'

    [-1, -1]
  end

  def direction_after_shift(direction)
    if direction == 'LEFT'
      return 'NORTH' if face == 'EAST'
      return 'SOUTH' if face == 'WEST'
      return 'WEST' if face == 'NORTH'
      return 'EAST' if face == 'SOUTH'
    end

    if direction == 'RIGHT'
      return 'NORTH' if face == 'WEST'
      return 'SOUTH' if face == 'EAST'
      return 'WEST' if face == 'SOUTH'
      return 'EAST' if face == 'NORTH'
    end

  end

  def move(_units, _direction)
    flash[:alert] = 'This piece is not initialized'
  end

  private

  def set_position(x_cord, y_cord, face)
    self.face = face
    self.x_cord = x_cord
    self.y_cord = y_cord
    [self.x_cord, self.y_cord, self.face]
  end



end