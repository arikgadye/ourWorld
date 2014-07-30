class Createarticle < ActiveRecord::Migration
  def change
  	create_table :articles do |t|
  		t.string :headline
  		t.string :snippet
  		t.string :url

  		t.timestamps
  	end
  end
end
