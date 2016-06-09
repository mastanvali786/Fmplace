class BidAttachment < ActiveRecord::Base
  belongs_to :bid
  validates :bid_id, :attachment,  presence: true
  mount_uploader :attachment, BidAttachmentUploader
  def name
    file_name
  end
  def url
    attachment_url
  end
end