#Online User model
class OnlineUser < ActiveRecord::Base
	belongs_to :user
	belongs_to :admin_user, class_name: 'AdminUser', foreign_key: :user_id
	default_scope { where("updated_at >= ?", 10.minutes.ago) }
	scope :guests, -> { where(user_type: 'GUEST') }
  scope :users, ->  { where(user_type: 'USER') }
  scope :admins, ->  { where(user_type: 'ADMIN') }
  scope :admin, ->  { where(user_type: 'ADMIN') }
end
