class LearningsController < ApplicationController
  def index
    @learnings = Learning.order(learned_on: :desc, created_at: :desc)

    if params[:tag].present?
      @learnings = @learnings.where("LOWER(tags) LIKE ?", "%#{params[:tag].downcase}%")
    end

    @tags = @learnings.map(&:tag_list).flatten.uniq.sort

    @learning = Learning.new
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

  def edit
    @learning = Learning.find(params[:id])
  end

  def update
    @learning = Learning.find(params[:id])
    if @learning.update(learning_params)
      redirect_to learnings_path, notice: "Learning updated successfully."
    else
      render :edit, status: :unprocessable_entity
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
    params.require(:learning).permit(:title, :body, :tags, :learned_on)
  end
end
