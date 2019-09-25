class Labeling < ApplicationRecord
  belongs_to :task, inverse_of: :labelings
  belongs_to :label
end
