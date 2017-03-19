class RenameNameColumnInUser < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :name, :fullname
  end
end
