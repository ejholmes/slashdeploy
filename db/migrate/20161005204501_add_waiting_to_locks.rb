class AddWaitingToLocks < ActiveRecord::Migration
  def change
    add_column :locks, :waiting, :boolean, default: false, null: false
  end
end
