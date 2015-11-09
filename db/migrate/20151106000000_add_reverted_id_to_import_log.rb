class AddRevertedIdToImportLog< ActiveRecord::Migration
  def up
    add_column :import_logs, :reverted_id, :integer, default:0



  end

  def down
    remove_column :import_logs, :reverted_logs
  end
end
