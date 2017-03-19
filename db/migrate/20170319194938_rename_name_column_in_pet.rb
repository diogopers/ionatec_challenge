class RenameNameColumnInPet < ActiveRecord::Migration[5.0]
  def change
    rename_column :pets, :name, :fullname
  end
end
