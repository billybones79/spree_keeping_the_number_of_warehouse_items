
class AddFilenameFieldToImportLogs < ActiveRecord::Migration
  def up
    add_column :import_logs, :filename, :string


  end

  def down
    remove_column :import_logs, :filename
  end
end
