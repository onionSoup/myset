class CreateHandmadeSets < ActiveRecord::Migration
  def change
    create_table :handmade_sets do |t|

      t.timestamps
    end
  end
end
