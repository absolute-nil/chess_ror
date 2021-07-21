# frozen_string_literal: true

class BoardController < ApplicationController
  before_action :init,  only: :index
  before_action :get_board, except: :index
  def index
    @board
  end

  def report
    if @board.my_piece.nil?
      flash[:alert] = 'you have to initialize the pawn first'
      redirect_back fallback_location: root_path
      return nil
    end
    id = @board.my_piece
    piece = Piece.get_instance_by_id(id)[0]

    @position = piece.current_position
    session['position'] = @position

    redirect_back fallback_location: root_path
  end

  def move

    if @board.my_piece.nil?
      flash[:alert] = 'you have to initialize the pawn first'
      redirect_back fallback_location: root_path
      return nil
    end

    @piece = Piece.get_instance_by_id(@board.my_piece)[0]

    success = @piece&.move(params[:units].to_i, 'FORWARD')
    flash[:notice] = 'Your move has been made' if success
    flash[:alert] = 'Not a valid move, Try again!' unless success
    redirect_back fallback_location: root_path

  end

  def change_direction
    if @board.my_piece.nil?
      flash[:alert] = 'you have to initialize the pawn first'
      redirect_back fallback_location: root_path
      return nil
    end

    direction = params['direction']

    if direction != 'LEFT' && direction != 'RIGHT'
      flash[:alert] = 'not a valid input'
      redirect_back fallback_location: root_path
      return nil
    end

    @piece = Piece.get_instance_by_id(@board.my_piece)[0]
    @piece.change_direction(params[:direction])
    flash[:notice] = 'Direction changed successfully'

    redirect_back fallback_location: root_path

  end

  # currently just creating new pawns (No other piece)
  def place
    x = params[:x].to_i
    y = params[:y].to_i
    color = params[:color]
    face = params[:face]
    if @board.move_within_bounds?(x, y) && %w[BLACK WHITE].include?(color) && %w[NORTH WEST SOUTH EAST].include?(face)
      piece = Pawn.new(id: @board.pieces,x_cord: x,y_cord: y,face: face, color: color, board: @board)
      @board.my_piece = piece.id
      @board.pieces += 1
      piece.id
      session['board'] = @board
      flash[:notice] = 'Your piece has been placed'

    else
      flash[:alert] = 'not a valid input'
    end
    redirect_back fallback_location: root_path
  end

  def end
    session.delete(:board)
    session.delete(:position)
    flash[:notice] = 'Game has been reset'
    redirect_to root_path
  end

  private

  def init
    if session['board'].nil?
      @board = Board.new(size: 8)
      session['board'] = @board
    else
      @board = Board.new(session['board'])
    end
  end

  def get_board
    @board = Board.new(session['board'])
  end

  # def place_params
  #   params.require(:board).permit( :x, :y, :face, :color)
  # end
  #
  # def move_params
  #   params.require(:board).permit(:units)
  # end
  #
  # def change_direction_params
  #   params.require(:board).permit(:direction)
  # end
end
