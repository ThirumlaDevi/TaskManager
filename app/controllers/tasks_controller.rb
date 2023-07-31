class TasksController < ApplicationController
  before_action :authenticate_user!
  def index
    # user_id need not be checked as only authenticated user is allowed to see tasks
    @tasks = Task.where(user_id: current_user_id).all
    respond_to do |format|
      format.html {render 'index'}
      # if task is nil return empty json or proper articles response
      format.json {render json: @tasks.to_json}
    end
  end

  def show
    @task = Task.find_by(id: params[:id], user_id: current_user_id)
    if @task.nil?
      render json: {message: "Either task not present or you do not have access to it"}, status: :not_found
    else
      respond_to do |format|
        format.html {render 'show'}
        format.json {render json: @task.to_json}
      end
    end
  end

  def new
    @task = Task.new
  end

  def create
    # add authenticated user id here
    new_task_params=task_params
    new_task_params["user_id"] = current_user_id
    
    @task = Task.new(new_task_params)
    if @task.save
      respond_to do |format|
        format.html {redirect_to @task}
        format.json {render json: @task.to_json, status: :created}
      end
    else
      respond_to do |format|
        format.html {render :new, status: :unprocessable_entity}
        format.json {render json: {message: "you do not have access to perform this action"}, status: :unauthorized}
      end
    end
  end

  def update
    # add authenticated user id here
   
    new_task_params=task_params
    new_task_params["user_id"] = current_user_id
    @task = Task.find_by(id: params[:id], user_id: current_user_id)
    if @task.update(new_task_params)
      respond_to do |format|
        format.html {redirect_to @task}
        format.json {render json: @task.to_json, status: :ok}
      end
    else
      respond_to do |format|
        format.html {render :new, status: :unprocessable_entity}
        format.json {render json: {message: "you do not have access to perform this action"}, status: :unauthorized}
      end
    end
  end

  def destroy
    @article = Task.find_by(id: params[:id], user_id: current_user_id)
    @article.destroy

    redirect_to tasks_path, status: :see_other
  end

  private
    def task_params
      params.require(:task).permit(:title, :description, :due_date)
      # params.require(:task).extract!(:title, :description)
    end

    def authenticate_user!
      super unless session['current_user_id'].present?
    end
    
    def current_user_id
      session['current_user_id']
    end
    
    def current_user
      @current_user ||= User.find(current_user_id)
    end
    
    # def allowed_access
    
    #   current_user
    # end
end

# <%= #current_user.email%>
  

