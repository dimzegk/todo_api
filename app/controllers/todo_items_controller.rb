class TodoItemsController < ApplicationController
  before_action :set_todo
  before_action :set_item, only: %i[show update destroy]

  def show
    render json: @item
  end

  def create
    item = @todo.todo_items.build(item_params)
    if item.save
      render json: item, status: :created
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy!
    head :no_content
  end

  private

    def set_todo
    tid = params[:id] || params[:todo_id]
    @todo = @current_user.todos.find(tid)
  end

  def set_item
    @item = @todo.todo_items.find(params[:iid])
  end

  def item_params
    params.require(:item).permit(:name, :done)
  end
end
