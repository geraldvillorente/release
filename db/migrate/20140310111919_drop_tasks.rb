class DropTasks < ActiveRecord::Migration
  def up
    drop_table :tasks
  end

  def down
    create_table "tasks" do |t|
      t.integer  "application_id"
      t.string   "version"
      t.text     "description"
      t.text     "application_changes"
      t.boolean  "additional_support_required", default: false
      t.boolean  "extended_support_required",   default: false
      t.datetime "created_at",                  null: false
      t.datetime "updated_at",                  null: false
      t.integer  "release_id"
    end
  end
end
