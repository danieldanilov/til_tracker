class StaticPagesController < ApplicationController
  def home
    @recent_learnings = Learning.order(created_at: :desc).limit(5)
  end

  def hire_me
  end

  def about
  end
end
