class Attachment < ActiveRecord::Base
  mount_uploader :file_name, AttachmentUploader
  belongs_to :project
  belongs_to :user
  belongs_to :bid
end
