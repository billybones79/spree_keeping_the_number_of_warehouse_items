
# This migration comes from spree (originally 20150707204155)
class addMessageFieldToImportLog < ActiveRecord::Migration
  def up
    create_table :import_logs do |t|
      t.string     :message

    end
  end

  def down
    remove_column :import_logs, :message
  end
end
