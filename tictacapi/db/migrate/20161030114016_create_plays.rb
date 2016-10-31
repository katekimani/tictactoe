class CreatePlays < ActiveRecord::Migration[5.0]
  def change
    create_table :plays do |t|
      t.integer :game_id
      t.integer :move
      t.string  :player

      t.timestamps null: false

    end


  end
end
