class CreateBoards < ActiveRecord::Migration[5.1]
  def change
    create_table :boards do |t|
      t.integer :size
      t.json :cells

      t.timestamps
    end
  end
end
