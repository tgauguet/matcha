class Like < ActiveRecord::Migration[5.1]
  def change
  	create_table :likes do |t|
      t.references :user_id
      t.integer :sender
      t.integer :receiver
      t.boolean :liked

      t.timestamps
    end
  end
end
