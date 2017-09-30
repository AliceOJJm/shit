class GamesController < ApplicationController

  def create
    p game_params
    board = Board.create(game_params.slice(:board)[:board])
    game = Game.new(game_params.except(:id).merge(identificator: game_params[:id], board: board))
    game.save
    render json: {status: :ok}
  end

  def show
    p game_params
    game = Game.find_by(identificator: game_params[:id])
    cells = game.board.cells
    ii, jj, answer = nil, nil, nil
    p '*' * 100
    p cells
    p '*' * 100
    cells.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        p i
        p j
        p "cell - #{cell}"
        p game_params[:color]
        if cell == game_params[:color].to_i
          answer = find_free(cells, i, j)
          ii, jj = i, j
          break if answer
        end
        p "#{answer}  -  answer"
      end
      break if answer
    end

    p '*' * 100
    p ii
    p jj
    p answer.map! { |e| e - 1 }
    p '*' * 100
    render json: {
      status: :ok,
      move_from: [ii, jj],
      move_to: answer
    }
  end

  def update
    p game_params
    changes = update_params[:changes]
    game = Game.find_by(identificator: update_params[:id])
    board = game.board
    cells = board.cells
    p '*' * 100
    p board
    p cells
    p '*' * 100
    changes.each do |line|
      cells[line[0]][line[1]] = line[3]
    end
    board.save

    render json: {status: :ok}
  end

  def destroy
    p game_params
    render json: {status: :ok}
  end

  private

  def find_free(array, row_index, col_index)
    p '*' * 100
    p row_index
    p col_index
    p '*' * 100
    cells = array.deep_dup
    cells.map! { |e| e.unshift(nil).push(nil) }.unshift(nil).push(nil)
    row_index += 1
    col_index += 1
    if row_index.odd?
      return [row_index - 1, col_index] if cells[row_index - 1].try(:[],col_index) == 0
      return [row_index + 1, col_index - 1] if cells[row_index + 1].try(:[],col_index - 1) == 0
      return [row_index, col_index - 1] if cells[row_index].try(:[],col_index - 1) == 0
      return [row_index, col_index + 1] if cells[row_index].try(:[],col_index + 1) == 0
      return [row_index - 1, col_index - 1] if cells[row_index - 1].try(:[],col_index - 1) == 0
      return [row_index + 1, col_index] if cells[row_index + 1].try(:[],col_index) == 0
    else
      return [row_index - 1 ,col_index] if cells[row_index - 1].try(:[],col_index) == 0
      return [row_index - 1 ,col_index + 1] if cells[row_index - 1].try(:[],col_index + 1) == 0
      return [row_index ,col_index - 1] if cells[row_index].try(:[],col_index - 1) == 0
      return [row_index ,col_index + 1] if cells[row_index].try(:[],col_index + 1) == 0
      return [row_index + 1 ,col_index] if cells[row_index + 1].try(:[],col_index) == 0
      return [row_index + 1 ,col_index + 1] if cells[row_index + 1].try(:[],col_index + 1) == 0
    end
  end

  def game_params
    params.permit!.except(:action, :controller)
  end

  def update_params
    params.permit!.except(:action, :controller)
  end
end
