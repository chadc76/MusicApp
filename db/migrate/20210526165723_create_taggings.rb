class CreateTaggings < ActiveRecord::Migration[6.1]
  def change
    create_table :taggings do |t|
      t.references :taggable, polymorphic: true, null: false
      t.integer :tag_id, null: false
      t.timestamps
    end
    add_index :taggings, [:tag_id, :taggable_type, :taggable_id], unique: true
    add_index :taggings, :tag_id
  end
end
