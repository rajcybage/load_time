class AddColumnsInUsersAndUrls < ActiveRecord::Migration
  def up
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  	add_column :urls, :threshold_value, :integer 
  end

  def down
    remove_column :users, :fist_name
  	remove_column :users, :last_name
  	remove_column :urls, :threshold_value 
  end
end
