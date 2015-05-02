class AddPdfPathToExam < ActiveRecord::Migration
  def change
    add_column :exams, :pdf_path, :string
  end
end
