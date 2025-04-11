class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :spotify_id
      t.string :spotify_access_token
      t.string :spotify_refresh_token
      t.datetime :token_expires_at
      t.timestamps
    end
  end
end
