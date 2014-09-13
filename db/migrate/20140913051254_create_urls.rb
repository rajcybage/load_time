class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :url_name
      t.integer :user_id

      t.timestamps
    end
  end
end
