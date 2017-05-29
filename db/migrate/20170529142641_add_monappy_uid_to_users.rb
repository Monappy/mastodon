class AddMonappyUidToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :monappy_uid, :integer
  end
end
