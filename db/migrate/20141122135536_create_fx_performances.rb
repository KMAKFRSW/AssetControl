class CreateFxPerformances < ActiveRecord::Migration
  def change
    create_table :fx_performances do |t|
      t.string :cur_code
      t.string :calc_date
      t.string :item
      t.string :data

      t.timestamps
    end
  end
end
