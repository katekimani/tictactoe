class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
    	t.string :status
    	t.string :winner

      t.timestamps null: false

    end


  end
end