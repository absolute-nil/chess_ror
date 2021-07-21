# frozen_string_literal: true

class BoardController < ApplicationController
  before_action :init,  only: :index
  before_action :board, except: :index
  def index
    byebug
    @board
  end

  def report
    if @board.my_piece.nil?
      flash[:alert] = 'you have to initialize the pawn first'
      redirect_back fallback_location: root_path
      return nil
    end
    id = @board.my_piece
    piece = Piece.get_instance_by_id(id, session)

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

    @piece = Piece.get_instance_by_id(@board.my_piece, session)
    success_piece = @piece&.move(params[:units].to_i, 'FORWARD')
    if !success_piece
      flash[:alert] = 'Not a valid move, Try again!'
    else
      success_piece.first_move = false
      update_piece(success_piece)
      flash[:notice] = 'Your move has been made'
    end
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

    @piece = Piece.get_instance_by_id(@board.my_piece, session)
    updated_piece = @piece.change_direction(params[:direction])
    update_piece(updated_piece)
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

      store_piece(piece)
    else
      flash[:alert] = 'not a valid input'
    end
    redirect_back fallback_location: root_path
  end

  def end
    session.delete(:board)
    session.delete(:position)
    session.delete(:pieces_array)
    flash[:notice] = 'Game has been reset'
    redirect_to root_path
  end



  private

  def update_piece(piece)
    session[:pieces_array].delete_if { |h| h["id"] == piece.id }
    session['pieces_array'] << piece
  end

  def init
    if session['board'].nil?
      @board = Board.new(size: 8)
      session['board'] = @board
    else
      @board = Board.new(session['board'])
    end

    session[:pieces_array] ||= [] if session[:pieces_array].nil? || session[:pieces_array].empty?
  end

  def store_piece(piece)
    session['pieces_array'] << piece
  end

  def board
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
