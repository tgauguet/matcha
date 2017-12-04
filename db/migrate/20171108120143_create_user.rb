include Paperclip::Schema

class CreateUser < ActiveRecord::Migration[5.1]
  def change
    create_table :Application_record do |t|
    end
  	create_table :users do |t|
      t.boolean :admin
      t.string :name
      t.string :firstname
      t.string :password
      t.string :login
      t.string :password_confirmation
      t.string :email
      t.boolean :confirmed
      t.string :gen
      t.string :state
      t.string :password_token
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
      t.string :img1
      t.string :img2
      t.string :img3
      t.string :img4
      t.string :img5
      t.string :password_digest
      t.boolean :email_confirmed, :default => false
      t.string :confirm_token

      t.timestamps
    end
  end
end
