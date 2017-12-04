class CreateTag < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.integer :user_id
      t.integer :tagging_id
    end
  end
end
