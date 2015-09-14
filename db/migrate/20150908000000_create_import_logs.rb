
# This migration comes from spree (originally 20150707204155)
class CreateImportLogs < ActiveRecord::Migration
  def up
    create_table :import_logs do |t|
      t.string     :number,               :limit => 15
      t.timestamps

    end
  end

  def down
    drop_table(:import_logs)
  end
end
