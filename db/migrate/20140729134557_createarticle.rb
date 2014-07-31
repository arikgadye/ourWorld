class Createarticle < ActiveRecord::Migration
  def change
  	create_table :articles do |t|
  		t.text :headline
  		t.text :snippet
  		t.string :url

  		t.timestamps
  	end
  end
end
