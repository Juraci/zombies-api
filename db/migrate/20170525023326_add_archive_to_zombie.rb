class AddArchiveToZombie < ActiveRecord::Migration[5.1]
  def change
    add_column :zombies, :archive, :boolean
  end
end
