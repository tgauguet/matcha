class AddPasswordTokenToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_token, :string
  end
end
