# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoardController, type: :controller do

  describe 'GET#report' do

    before do
      session['board'] = Board.new(size: 8)
      session['position'] = [0, 0, 'NORTH', 'BLACK']
      session['pieces_array'] =
        [{ 'id' => 0, 'x_cord' => 1, 'y_cord' => 4, 'face' => 'NORTH', 'color' => 'BLACK',
           'board' => { 'size' => 8, 'origin_x' => 0, 'origin_y' => 0, 'my_piece' => 0, 'pieces' => 1 }, 'first_move' => false }]
    end
    subject(:submit_request) { get :report, session: session, xhr: true }

    it { expect(submit_request).to change(session['position']).to([1, 3, 'NORTH', 'BLACK']) }
  end

  describe 'POST#place' do

    before do
      session['board'] = Board.new(size: 8)
      session['pieces_array'] = nil
    end

    context 'valid place command' do
      subject(:submit_request) {
 post :place, session: session, params: { id: 0, x: 1, y: 1, color: 'WHITE', face: 'NORTH' }, xhr: true }

      it {
 expect(submit_request).to change(session['pieces_array']).from(nil).to([{ 'id' => 0, 'x_cord' => 1, 'y_cord' => 1,
                                                                           'face' => 'NORTH', 'color' => 'WHITE', 'board' => { 'size' => 8, 'origin_x' => 0, 'origin_y' => 0, 'my_piece' => 0, 'pieces' => 1 }, 'first_move' => true }])}
    end

    context 'invalid place command' do
      subject(:submit_request) {
 post :place, session: session, params: { id: 0, x: -1, y: -1, color: 'WHITE', face: 'NORTH' }, xhr: true }

      it { expect(submit_request).not_to change(session['pieces_array']).from(nil) }

    end
  end


  describe 'PATCH#move' do

    before do
      session['board'] = Board.new(size: 8)
      session['position'] = [0, 0, 'NORTH', 'BLACK']
    end

    context 'when first move' do
      before do
        session['pieces_array'] =
          [{ 'id' => 0, 'x_cord' => 1, 'y_cord' => 4, 'face' => 'NORTH', 'color' => 'BLACK',
             'board' => { 'size' => 8, 'origin_x' => 0, 'origin_y' => 0, 'my_piece' => 0, 'pieces' => 1 }, 'first_move' => true }]
      end

      subject(:submit_request) { patch :move, session: session, params: { units: 2 }, xhr: true }

      it {
 expect(submit_request).to change(session['pieces_array']).to([{ 'id' => 0, 'x_cord' => 1, 'y_cord' => 6,
                                                                 'face' => 'NORTH', 'color' => 'BLACK', 'board' => { 'size' => 8, 'origin_x' => 0, 'origin_y' => 0, 'my_piece' => 0, 'pieces' => 1 }, 'first_move' => true }])}
    end

    context 'when not first move' do
      before do
        session['pieces_array'] =
          [{ 'id' => 0, 'x_cord' => 1, 'y_cord' => 4, 'face' => 'NORTH', 'color' => 'BLACK',
             'board' => { 'size' => 8, 'origin_x' => 0, 'origin_y' => 0, 'my_piece' => 0, 'pieces' => 1 }, 'first_move' => false }]
      end

      context '2 units move' do
        subject(:submit_request) { patch :move, session: session, params: { units: 2 }, xhr: true }

        it {
 expect(submit_request).not_to change(session['pieces_array']).to([{ 'id' => 0, 'x_cord' => 1, 'y_cord' => 6,
                                                                     'face' => 'NORTH', 'color' => 'BLACK', 'board' => { 'size' => 8, 'origin_x' => 0, 'origin_y' => 0, 'my_piece' => 0, 'pieces' => 1 }, 'first_move' => true }])}
      end

      context '1 units move' do
        subject(:submit_request) { patch :move, session: session, params: { units: 2 }, xhr: true }

        it {
 expect(submit_request).to change(session['pieces_array']).to([{ 'id' => 0, 'x_cord' => 1, 'y_cord' => 5,
                                                                 'face' => 'NORTH', 'color' => 'BLACK', 'board' => { 'size' => 8, 'origin_x' => 0, 'origin_y' => 0, 'my_piece' => 0, 'pieces' => 1 }, 'first_move' => true }])}
      end

    end

  end

  describe 'PATCH#change_direction' do

    before do
      session['board'] = Board.new(size: 8)
      session['position'] = [0, 0, 'NORTH', 'BLACK']
      session['pieces_array'] =
        [{ 'id' => 0, 'x_cord' => 1, 'y_cord' => 4, 'face' => 'NORTH', 'color' => 'BLACK',
           'board' => { 'size' => 8, 'origin_x' => 0, 'origin_y' => 0, 'my_piece' => 0, 'pieces' => 1 }, 'first_move' => true }]
    end

    subject(:submit_request) { patch :change_direction, session: session, params: { direction: 'LEFT' }, xhr: true }

    it {
      expect(submit_request).to change(session['pieces_array']).to([{ 'id' => 0, 'x_cord' => 1, 'y_cord' => 4,
                                                                      'face' => 'WEST', 'color' => 'BLACK', 'board' => { 'size' => 8, 'origin_x' => 0, 'origin_y' => 0, 'my_piece' => 0, 'pieces' => 1 }, 'first_move' => true }])}
  end



  describe 'DELETE#end' do

    before do
      session['board'] = Board.new(size: 8)
      session['position'] = [0, 0, 'NORTH', 'BLACK']
      session['pieces_array'] =
        [{ 'id' => 0, 'x_cord' => 1, 'y_cord' => 4, 'face' => 'NORTH', 'color' => 'BLACK',
           'board' => { 'size' => 8, 'origin_x' => 0, 'origin_y' => 0, 'my_piece' => 0, 'pieces' => 1 }, 'first_move' => true }]
    end

    subject(:submit_request) { delete :end, session: session, xhr: true }

    it { expect(submit_request).to change(session['pieces_array']).to(nil) }
    it { expect(submit_request).to change(session['position']).to(nil) }
    it { expect(submit_request).to change(session['board']).to(nil) }
  end

end
