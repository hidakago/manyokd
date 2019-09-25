class Label < ApplicationRecord
  has_many :labelings, dependent: :destroy
  has_many :labeling_tasks, through: :labeling, source: :task
end
