class DeleteAttachmentColumnFromExams < ActiveRecord::Migration
  def change
    remove_column :exams, :attachment
  end
end
