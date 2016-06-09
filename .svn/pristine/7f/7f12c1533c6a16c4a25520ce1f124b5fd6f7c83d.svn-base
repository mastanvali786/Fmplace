class ProjectFile <  ActiveRecord::Base
  mount_uploader :file, FileUploader
  validates :file, :user_id, :project_id, presence: true
  belongs_to :project
  scope :sort, ->(sort_by) {order("#{sort_by} ASC")}
  belongs_to :user
  before_validation(on: :create) do
    current_user = User.current
    if (current_user)
      self.user_id ||= current_user.id
    end
  end

  def uploader
    user
  end
  def uploaded_at
    created_at
  end

  def url
    file_url
  end

  def full_url
    "#{SITE_URL}#{url}"
  end
end