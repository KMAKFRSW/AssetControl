class CreateBolingerBands < ActiveRecord::Migration
  def change
    create_table :bolinger_bands do |t|
      t.string :calc_date
      t.string :cur_code
      t.string :term
      t.string :MA
      t.string :plus1sigma
      t.string :plus2sigma
      t.string :plus3sigma
      t.string :minus1sigma
      t.string :minus2sigma
      t.string :minus3sigma

      t.timestamps
    end
  end
end
