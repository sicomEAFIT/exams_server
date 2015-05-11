class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :number
      t.string :image
      t.string :pdf
      t.integer :exam_id

      t.timestamps null: false
    end
  end
end
