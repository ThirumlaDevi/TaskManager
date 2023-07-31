ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../../config/environment", __FILE__)
require 'rspec/rails'

RSpec.describe Task, type: :model do
    context "session maintainance checks" do
        before(:all) do
            @user = User.create(email: "test2@gmail.com",password: "123456", address: "Ireland, Dublin")
        end

        after(:all) do 
            UserLocationInfo.find_by(user_id:@user.id).delete
            User.destroy(@user.id)
            Task.where(title: "task1").destroy_all
        end

        it "Cannot create task without title" do
            task = Task.create(user_id: @user.id, description: "KT with Omid", due_date: "2022-01-01")
            expect(task.id).to eq(nil)
        end

        it "Cannot create task without description" do
            task = Task.create(user_id: @user.id, title: "task1", due_date: "2022-01-01")
            expect(task.id).to eq(nil)
        end
    
        it "Cannot create task without user" do
            task = Task.create(title: "task1", description: "KT with Omid", due_date: "2022-01-01")
            expect(task.id).to eq(nil)
        end

        it "Cannot create task with short description" do
            task = Task.create(user_id: @user.id, title: "task1", description: "KT", due_date: "2022-01-01")
            expect(task.id).to eq(nil)
        end

        it "Cannot create task with title, description, due_date and user id if user doesn't exists" do
            task = Task.create(user_id: nil, title: "task1", description: "KT with Omid", due_date: "2022-01-01")
            expect(task.id).to eq(nil)
        end

        it "Can create task with title, description, due_date and user id if user exists" do
            task = Task.create(user_id: @user.id, title: "task1", description: "KT with Omid", due_date: "2022-01-01")
            expect(task.id).not_to eq(nil)
        end
    
    end
end