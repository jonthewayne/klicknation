class DeviseCreateAdminToolUsers < ActiveRecord::Migration
  def self.up
    create_table(:admin_tool_users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable

      t.string :first_name
      t.string :last_name
      t.integer :roles_mask
      t.timestamps
    end

    add_index :admin_tool_users, :email,                :unique => true
    add_index :admin_tool_users, :reset_password_token, :unique => true
    # add_index :admin_tool_users, :confirmation_token,   :unique => true
    # add_index :admin_tool_users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :admin_tool_users
  end
end
