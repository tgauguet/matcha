class User < ActiveRecord::Migration[5.1]
  def change
    create_table :Application_record do |t|
    end
  	create_table :users do |t|
      t.boolean :admin
      t.string :name
      t.string :firstname
      t.string :password
      t.string :password_confirmation
      t.string :email
      t.boolean :confirmed
      t.boolean :gender
      t.string :state
      t.string :country
      t.string :street
      t.text :bio
      t.string :interested_in
      t.string :city
      t.integer :tag_id
      t.integer :interest_id
      t.integer :score
      t.float :latitude
      t.boolean :fake_account
      t.float :longitude
      t.integer :connection_id

      t.timestamps
    end
  end
end
