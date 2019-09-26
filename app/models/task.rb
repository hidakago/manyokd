class Task < ApplicationRecord
  validates :name, presence: true
  validate :not_entered_deadline

  # scope :search, -> (name_key, status_key) {where('(name LIKE ?) AND (status = ?)', "%#{name_key}%", status_key)}
  scope :search, -> (name_key, status_key, user_id_key) {where('(name LIKE ?) AND (status = ?) AND (user_id = ?)', "%#{name_key}%", status_key, user_id_key)}

  enum priority: { priority_low: 0, priority_medium: 1, priority_high: 2 }

  belongs_to :user
  has_many :labelings, dependent: :destroy, inverse_of: :task
  has_many :labels, through: :labelings
  accepts_nested_attributes_for :labelings, allow_destroy: true

  def not_entered_deadline
    if deadline == "0000-00-00"
      errors.add(:deadline, "に適切な年月日を設定してください")
    end
  end
end
