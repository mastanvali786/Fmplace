class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  def visible_name
  	"#{first_name} #{last_name}"
  end
end
