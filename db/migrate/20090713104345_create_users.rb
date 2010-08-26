class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string  :email

      t.string  :first_name
      t.string  :last_name

      t.string  :roles

      t.string  :crypted_password
      t.string  :password_salt
      t.string  :persistence_token
      t.string  :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.string  :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability
      
      # optional, see Authlogic::Session::MagicColumns
      t.integer   :login_count,         :null => false, :default => 0
      t.integer   :failed_login_count,  :null => false, :default => 0
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end