class CreateTracks < ActiveRecord::Migration[6.1]
  def change
    create_table :tracks do |t|
      t.string :title, null: false
      t.integer :ord, null: false
      t.integer :album_id, null: false
      t.boolean :bonus_track, default: false
      t.text :lyrics

      t.timestamps
    end

    add_index :tracks, :album_id
    add_index :tracks, [:ord, :album_id], unique: true
  end
end
