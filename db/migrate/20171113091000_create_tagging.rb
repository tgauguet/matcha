class CreateTagging < ActiveRecord::Migration[5.1]
  def change
    create_table :taggings do |t|
      t.string :name
      t.timestamps
    end
    add_index :taggings, :name
  end
end
