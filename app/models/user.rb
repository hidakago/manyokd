class User < ApplicationRecord
  before_update :check_admin_user
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: true

  before_validation { email.downcase! }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  has_many :tasks

  private

  def check_admin_user
    if User.where(admin_allowed: :true).count == 1 && !self.admin_allowed?
      throw(:abort)
    end
  end
end
