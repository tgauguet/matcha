include Paperclip::Schema

class Image < ActiveRecord::Migration[5.1]
  def change
  	create_table :images do |t|
      t.integer :user_id
      t.attachment :image
      t.boolean :main

      t.timestamps
    end
  end
end
