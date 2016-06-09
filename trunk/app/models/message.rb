class Message < ActiveRecord::Base
  include Messageable
  attr_reader :skip_broadcast
  has_many :attachments, class_name: "MessageAttachment"
  belongs_to :sender, class_name: "User", foreign_key: "created_by"
  belongs_to :receiver, class_name: "User", foreign_key: "to"
  has_many :conversations
  validates :from, :subject, :created_by, :body, :type, presence: true
  scope :unread, ->  { where(:read => false) }
  scope :invites, ->  { where(:type => "Invite") }
  scope :proposals_projects, ->  { where type: ["Proposal", "Project"] }
  self.inheritance_column = 'column_that_is_not_type'
  FOLDERS = %W(sent inbox deleted saved)
  TYPES = %w(proposals_projects proposals normal invites)
  FOLDERS.each do |folder| 
    scope folder, -> { where(:folder => folder) } 
  end
  TYPES.each do |type|
    scope type, -> { where(:type => type.titleize.split) }
  end
  after_create :publish_new_message_created

  before_validation(on: :create) do
    current_user = User.current
    if current_user
      if self.created_by.nil?
        self.created_by = current_user.id
      end
      self.from ||= current_user.first_name
    end
  end

  def receiver_copy!(receiver)
    copy = dup
    copy.folder = "inbox"
    copy.sender_message_id = self.id
    #copy.created_by = receiver.id
    copy.other_message_id = self.id
    copy.save!
    copy
  end

  def sent_at
    self[:sent_at].present? ? self[:sent_at] : created_at
  end

  def project?
    type.downcase == "project"
  end

  def project
    if project?
      ProjectMessage.project(sender_message_id || id)
    end
  end

  def self.normal_message(attrs={})
    new attrs.merge(type:"Normal")
  end

  def normal?
    type.downcase == "normal"
  end

  def inboxed?
    folder == "inbox"
  end
  def publish_new_message_created
    broadcast("new_message", self) unless self.inboxed?
  end
end