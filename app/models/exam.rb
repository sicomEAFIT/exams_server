class Exam < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  mount_uploader :pdf, PdfUploader 
  validates :name, presence: true
end
