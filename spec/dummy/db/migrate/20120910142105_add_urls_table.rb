class AddUrlsTable < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :url
    end
  end
end
