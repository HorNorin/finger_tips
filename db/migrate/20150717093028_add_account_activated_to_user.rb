class AddAccountActivatedToUser < ActiveRecord::Migration
  def change
    add_column :users, :account_activated, :boolean, default: false
  end
end
