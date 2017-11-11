class Conversation < ActiveRecord::Migration[5.1]
  def change
  	create_table :conversations do |t|
      t.integer :connection_id
      t.string :title

      t.timestamps
    end
  end
end
