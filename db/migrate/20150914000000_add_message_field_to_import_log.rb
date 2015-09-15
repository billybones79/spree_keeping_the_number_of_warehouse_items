
# This migration comes from spree (originally 20150707204155)
class AddMessageFieldToImportLog < ActiveRecord::Migration
  def up
    add_column :import_logs, :message, :string

    end
  end

  def down
    remove_column :import_logs, :message
  end
end
