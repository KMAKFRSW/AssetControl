class CreatePivots < ActiveRecord::Migration
  def change
    create_table :pivots do |t|
      t.string :calc_date
      t.string :cur_code
      t.string :cycle
      t.string :P
      t.string :R1
      t.string :R2
      t.string :R3
      t.string :S1
      t.string :S2
      t.string :S3

      t.timestamps
    end
  end
end
