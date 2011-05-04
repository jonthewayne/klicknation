class AdminToolClaim < ActiveRecord::Base
  belongs_to :claimable, :polymorphic => true
  belongs_to :admin_tool_user
end
