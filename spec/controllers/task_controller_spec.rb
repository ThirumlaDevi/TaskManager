ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../../config/environment", __FILE__)
require 'rspec/rails'

describe TasksController, type: :controller do

  context "create" do
    before(:all) do
        @user = User.create(email: "test1@gmail.com",password: "123456", address: "Ireland, Dublin")
    end

    before(:each) do 
        allow_any_instance_of(TasksController).to receive(:authenticate_user!).and_return(true) 
        TasksController.any_instance.stub(:current_user_id).and_return(@user.id)
    end

    after(:each) do 
        TasksController.any_instance.unstub(:authenticate_user!)
        TasksController.any_instance.unstub(:current_user_id)
    end

    after(:all) do 
        UserLocationInfo.find_by(user_id:@user.id).delete
        User.destroy(@user.id)
        Task.where(title: "task1").destroy_all
    end
      it "should be able to create Task" do
        # making json request
        request.headers['Content-Type'] = 'application/json'
        request.headers['Accept'] = 'application/json'
        post :create, params: {task:{"title": "task1","description": "KT with Omid",  "due_date": "2022-01-01"}}
        expect(response.status).to eq(201)
      end

      it "not should be able to create task when not signed in" do
        # making json request
        request.headers['Content-Type'] = 'application/json'
        request.headers['Accept'] = 'application/json'
        TasksController.any_instance.unstub(:current_user_id)
        TasksController.any_instance.stub(:current_user_id).and_return(nil)
        post :create, params: {task:{"title": "task1","description": "KT with Omid",  "due_date": "2022-01-01"}}
        expect(response.status).to eq(401)
      end
  end

  context "get" do
    before(:all) do
        @user = User.create(email: "test1@gmail.com",password: "123456", address: "Ireland, Dublin")
    end

    before(:each) do 
        allow_any_instance_of(TasksController).to receive(:authenticate_user!).and_return(true) 
        TasksController.any_instance.stub(:current_user_id).and_return(@user.id)
    end

    after(:each) do 
        TasksController.any_instance.unstub(:authenticate_user!)
        TasksController.any_instance.unstub(:current_user_id)
    end

    after(:all) do 
        UserLocationInfo.find_by(user_id:@user.id).delete
        User.destroy(@user.id)
        Task.where(title: "task1").destroy_all
    end
      
    it "should get all available Tasks of signed_in user only" do
        get :index
        expect(response.status).to eq(200)
    end

      it "should get Task by index" do
        # creating Task object directly
        task = Task.create(user_id: @user.id, title: "task1", description: "KT with Omid", due_date: "2022-01-01")
        get :show, params: {id: task.id}
        expect(response.status).to eq(200)
      end

      it "fail to get Task index not owned by current user" do
        # creating Task object directly
        task = Task.create(user_id: @user.id, title: "task1", description: "KT with Omid", due_date: "2022-01-01")
        TasksController.any_instance.unstub(:current_user_id)
        userB = User.create(email: "test2@gmail.com",password: "123456", address: "Ireland, Dublin")
        TasksController.any_instance.stub(:current_user_id).and_return(userB.id)
        get :show, params: {id: task.id}
        expect(response.status).to eq(404)
        #delete previously created userB information
        UserLocationInfo.find_by(user_id:userB.id).delete
        User.destroy(userB.id)
     end
  end

#   context "edit" do
#       it "should edit specific Tasks" do
#           request.headers['Content-Type'] = 'application/json'
#           request.headers['Accept'] = 'application/json'
#           Task = Task.create(title: "task1", "body": "KT with Omid")
#           patch :update, params: {"id": Task.id, Task:{"title": "task1","body": "KT with Omid and team"}}
#           expect(response.status).to eq(200)
#           updated_Task = Task.find(Task.id)
#           expect(updated_Task.body).to eq("KT with Omid and team")
#       end
#   end
end
