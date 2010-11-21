class CreatePieces < ActiveRecord::Migration
  def self.up
    create_table :pieces do |t|
      t.string :name, :null => false
      t.text :description
      t.integer :attack
      t.integer :defense
      t.integer :movement
      t.integer :cost
  
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
  
      t.timestamps
    end
  end

  def self.down
    drop_table :pieces
  end
end
