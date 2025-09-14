class TodoItem < ApplicationRecord
  belongs_to :todo
  attribute :done, :boolean, default: false
  validates :name, presence: true
end
