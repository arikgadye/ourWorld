class Createuser < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :username
  		t.string :google_id
  		t.text :photo
  		t.string :name

  		t.timestamps
  	end
  end
end
