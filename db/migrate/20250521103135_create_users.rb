class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :phone
      t.string :password_digest
      t.string :two_factor_secret
      t.boolean :two_factor_enabled

      t.timestamps
    end
  end
end
