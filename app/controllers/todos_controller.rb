class TodosController < ApplicationController
  before_action :set_todo, only: %i[show update destroy]

  def index
    todos = @current_user.todos.includes(:todo_items)
    render json: todos.as_json(include: :todo_items)
  end

  def create
    todo = @current_user.todos.build(todo_params)
    if todo.save
      render json: todo, status: :created
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @todo.as_json(include: :todo_items)
  end

  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy!
    head :no_content
  end

  private

  def set_todo
    @todo = @current_user.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title)
  end
end
