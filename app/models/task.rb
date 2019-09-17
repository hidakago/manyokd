class Task < ApplicationRecord
  validates :name, presence: true
  validate :not_entered_deadline

  scope :search, -> (name_key, status_key) {where('(name LIKE ?) AND (status = ?)', "%#{name_key}%", status_key)}

  def not_entered_deadline
    if deadline == "0000-00-00"
      errors.add(:deadline, "に適切な年月日を設定してください")
    end
  end
end
