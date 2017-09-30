class GamesController < ApplicationController

  def create
    p params
    board = Board.create(params.slice(:size, :cells))
    game = Game.new(params.except(:id).merge(identificator: params[:id], board: board))
    game.save
    render json: {status: :ok}
  end

  def show
    p params
    game = Game.find_by(identificator: params[:id])
    cells = game.board.cells
    ii, jj, answer = nil, nil, nil
    cells.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        if cell == params[:color]
          answer = find_free(cells, i, j)
          ii, jj = i, j
          break if answer
        end
      end
      break if answer
    end
    p '*' * 100
    p ii
    p jj
    p answer
    p '*' * 100
    render json: {
      status: :ok,
      move_from: [ii, jj],
      move_to: answer
    }
  end

  def update
    p params
    render json: {status: :ok}
  end

  def destroy
    p params
    render json: {status: :ok}
  end

  private

  def find_free(cells, i, j)
    cells.map! { |e| e.unshift(nil).push(nil) }.unshift(nil).push(nil)
    if i.odd?
      return [row_index - 1, col_index] if cells[row_index - 1].try(:[],col_index) == 0
      return [row_index + 1, col_index] if cells[row_index + 1].try(:[],col_index) == 0
      return [row_index, col_index - 1] if cells[row_index].try(:[],col_index - 1) == 0
      return [row_index, col_index + 1] if cells[row_index].try(:[],col_index + 1) == 0
      return [row_index - 1, col_index - 1] if cells[row_index - 1].try(:[],col_index - 1) == 0
      return [row_index - 1, col_index + 1] if cells[row_index - 1].try(:[],col_index + 1) == 0
    else
      return [row_index - 1 ,col_index] if cells[row_index - 1].try(:[],col_index) == 0
      return [row_index + 1 ,col_index] if cells[row_index + 1].try(:[],col_index) == 0
      return [row_index ,col_index - 1] if cells[row_index].try(:[],col_index - 1) == 0
      return [row_index ,col_index + 1] if cells[row_index].try(:[],col_index + 1) == 0
      return [row_index + 1 ,col_index - 1] if cells[row_index + 1].try(:[],col_index - 1) == 0
      return [row_index + 1 ,col_index + 1] if cells[row_index + 1].try(:[],col_index + 1) == 0
    end
  end

end
