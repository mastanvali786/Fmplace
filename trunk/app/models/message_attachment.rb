class MessageAttachment < ActiveRecord::Base
  belongs_to :message
  mount_uploader :attachment, MessageAttachmentUploader
end