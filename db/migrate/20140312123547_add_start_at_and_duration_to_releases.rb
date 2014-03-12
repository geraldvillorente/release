class AddStartAtAndDurationToReleases < ActiveRecord::Migration
  def change
    add_column :releases, :start_at, :datetime
    add_column :releases, :end_at, :datetime
  end
end
