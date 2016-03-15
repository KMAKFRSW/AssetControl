class CreateRsis < ActiveRecord::Migration
  def change
    create_table :rsis do |t|
      t.string :calc_date
      t.string :cur_code
      t.string :term
      t.string :RSI

      t.timestamps
    end
  end
end
