class AddColumnCalculatedValue < ActiveRecord::Migration
  def up
  	add_column :urls, :calculated_time, :integer
  end

  def down
    remove_column :urls, :calculated_time
  end
end
