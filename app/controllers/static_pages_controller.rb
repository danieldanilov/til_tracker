class StaticPagesController < ApplicationController
  # Reason: home action removed, learnings#index is now root.
  # def home
  #   @recent_learnings = Learning.order(created_at: :desc).limit(5)
  # end

  def hire_me
  end

  def about
  end

  def writing_samples
  end
end
