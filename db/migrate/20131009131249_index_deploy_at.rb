class IndexDeployAt < ActiveRecord::Migration
  def up
    add_index :releases, :deploy_at
  end

  def down
    remove_index :releases, :deploy_at
  end
end
