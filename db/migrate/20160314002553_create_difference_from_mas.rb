class CreateDifferenceFromMas < ActiveRecord::Migration
  def change
    create_table :difference_from_mas do |t|
      t.string :calc_date
      t.string :cur_code
      t.string :term
      t.string :DFMA

      t.timestamps
    end
  end
end
