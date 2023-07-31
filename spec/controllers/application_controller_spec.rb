ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../../config/environment", __FILE__)
require 'rspec/rails'

describe ApplicationController, type: :controller do

  context "session maintainance checks" do

    # before(:each) do
    #   @user = User.create(email: "test1@gmail.com",password: "123456", address: "Ireland, Dublin")
    #   ApplicationController.any_instance.stub(:current_user).and_return(@user)
    #   ApplicationController.any_instance.stub(new_user_session_path).and_return("")
    #   allow_any_instance_of(ActionDispatch::Request::Session).to receive(session).and_return({current_user_id:@user.id}) 
    # end

    # after(:each) do 
    #   ApplicationController.any_instance.unstub(:current_user)
    #   ApplicationController.any_instance.unstub(new_user_session_path)
    # end

    # it "clear existing user session on new sign in or sign up" do
    #    this.after_sign_up_path_for
    #   #  debugger
    #     # stub request.session[:current_user_id] = 1
    #     # call sign up
    #     # check if request.session[:current_user_id].nil?
    # end

  #   it "Post successful sign in session gets updated" do
  #       # stub that sign is successfull
  #       # stub current user 
  #       # check if request.session[:current_user_id] not null
  #   end

   end

end