class Exam < ActiveRecord::Base
  mount_uploader :pdf, PdfUploader 
  has_many :pages
  accepts_nested_attributes_for :pages
  validates :name, presence: true
end
