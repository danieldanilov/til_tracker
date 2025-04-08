class LearningsController < ApplicationController
  def index
    @learnings = Learning.order(created_at: :desc)
  end

  def new
    @learning = Learning.new
  end

  def create
    @learning = Learning.new(learning_params)

    if @learning.save
      redirect_to learnings_path, notice: "Learning logged successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy_multiple
    learnings_to_delete = Learning.where(id: params[:learning_ids])
    deleted_count = learnings_to_delete.count

    if learnings_to_delete.destroy_all
      redirect_to learnings_path, notice: "#{view_context.pluralize(deleted_count, 'learning')} deleted successfully."
    else
      # This case is less likely with destroy_all unless callbacks fail
      redirect_to learnings_path, alert: "Error deleting learnings."
    end
  end

  private

  def learning_params
    params.require(:learning).permit(:title, :body, :tags)
  end
end
