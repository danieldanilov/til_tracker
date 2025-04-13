class Learning < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true

  def tag_list
    # Reason: Provide a simple way to access normalized tags for view display/filtering.
    tags.to_s.split(",").map(&:strip).map(&:downcase).reject(&:blank?).uniq
  end
end
