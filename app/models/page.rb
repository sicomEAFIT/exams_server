class Page < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :exam
end
