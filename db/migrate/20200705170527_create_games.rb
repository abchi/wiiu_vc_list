class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games, id: false do |t|
      t.integer :id, null: false
      t.string :name
      t.string :hardware
      t.string :genre
      t.date :relese_date
      t.integer :price
      t.string :maker
      t.string :soft_type
      t.string :title_url
      t.string :image_url

      t.timestamps

      t.index :id, unique: true
    end
  end
end
