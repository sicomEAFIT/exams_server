class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.string :name
      t.string :attachment

      t.timestamps null: false
    end
  end
end
