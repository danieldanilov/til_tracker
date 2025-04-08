class Learning < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
end
