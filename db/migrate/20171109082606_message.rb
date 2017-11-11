class Message < ActiveRecord::Migration[5.1]
  def change
  	create_table :messages do |t|
      t.integer :user_id
      t.text :content
      t.boolean :read
      t.integer :conversation_id

      t.timestamps
    end
  end
end
