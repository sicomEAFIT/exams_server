class RenameColumnPdfPathToExams < ActiveRecord::Migration
  def change
    rename_column :exams, :pdf_path, :pdf
  end
end
