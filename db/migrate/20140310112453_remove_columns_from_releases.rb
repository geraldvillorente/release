class RemoveColumnsFromReleases < ActiveRecord::Migration
  def up
    remove_column :releases, :notes
    remove_column :releases, :deploy_at
    remove_column :releases, :released
    remove_column :releases, :released_at
    remove_column :releases, :product_team_members
    remove_column :releases, :summary
    remove_column :releases, :description_of_changes
    remove_column :releases, :additional_support_notes
    remove_column :releases, :extended_test_period_notes
  end

  def down
    add_column :releases, :notes, :text
    add_column :releases, :deploy_at, :datetime
    add_column :releases, :released, :boolean
    add_column :releases, :released_at, :datetime
    add_column :releases, :product_team_members, :text
    add_column :releases, :summary, :text
    add_column :releases, :description_of_changes, :text
    add_column :releases, :additional_support_notes, :text
    add_column :releases, :extended_test_period_notes, :text
  end
end
