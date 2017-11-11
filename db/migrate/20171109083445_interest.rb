class Interest < ActiveRecord::Migration[5.1]
  def change
  	create_table :interests do |t|
      t.string :content
      t.references :user_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
