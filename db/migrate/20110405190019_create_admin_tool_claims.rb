class CreateAdminToolClaims < ActiveRecord::Migration
  def self.up
    create_table :admin_tool_claims do |t|
      t.integer :claimable_id
      t.string :claimable_type
      t.integer :admin_tool_user_id
      t.string :tag

      t.timestamps
    end
  end

  def self.down
    drop_table :admin_tool_claims
  end
end
