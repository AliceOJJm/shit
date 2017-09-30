class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :identificator
      t.boolean :first_turn
      t.boolean :training
      t.json :jumps
      t.references :board, foreign_key: true
      t.integer :color

      t.timestamps
    end
  end
end
