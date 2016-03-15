class CreateStochastics < ActiveRecord::Migration
  def change
    create_table :stochastics do |t|
      t.string :calc_date
      t.string :cur_code
      t.string :kterm
      t.string :dterm
      t.string :K
      t.string :D
      t.string :SD

      t.timestamps
    end
  end
end
