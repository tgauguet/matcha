class CreateConnection < ActiveRecord::Migration[5.1]
  def change
  	create_table :connections do |t|
      t.references :user_id
      t.boolean :blocked
      t.boolean :visited

      t.timestamps
    end
  end
end
