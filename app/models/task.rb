class Task < ApplicationRecord
  validates :name, presence: true
  validate :not_entered_deadline

  def not_entered_deadline
    if deadline == "0000-00-00"
      errors.add(:deadline, "に適切な年月日を設定してください")
    end
  end
end
