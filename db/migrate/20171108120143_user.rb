class User < ActiveRecord::Migration[5.1]
  def change
  	create_table :users do |t|
      t.boolean :admin
      t.string :name
      t.string :firstname
      t.string :password
      t.string :password_confirmation
      t.string :email
      t.boolean :confirmed
      t.boolean :gender
      t.text :bio
      t.string :city
      t.integer :score

      t.timestamps
    end
  end
end
