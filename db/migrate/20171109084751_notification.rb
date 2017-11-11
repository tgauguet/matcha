class Notification < ActiveRecord::Migration[5.1]
  def change
  	create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :message, foreign_key: true
      t.integer :identifier
      t.string :type
      t.boolean :read
      t.references :conversation, foreign_key: true

      t.timestamps
    end
  end
end
