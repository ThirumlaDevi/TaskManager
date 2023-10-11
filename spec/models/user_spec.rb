ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../../config/environment', __FILE__)
require 'rspec/rails'

RSpec.describe User, type: :model do
  context 'session maintainance checks' do
    it 'add userlocation info if user is saved' do
      user = User.create(email: 'test3@gmail.com', password: '123456', address: 'Ireland, Dublin')
      expect(UserLocationInfo.find_by(user_id: user.id).id).not_to eq(nil)
      # cleanup
      UserLocationInfo.find_by(user_id:user.id).delete
      User.destroy(user.id)
    end

    it "donot allow removal of user before removing it's user location reference" do
      user = User.create(email: 'test3@gmail.com', password: '123456', address: 'Ireland, Dublin')
      begin
        User.destroy(user.id)
        raise 'test failed'
      rescue ActiveRecord::InvalidForeignKey
        UserLocationInfo.find_by(user_id: user.id).delete
        User.destroy(user.id)
      end
    end

    it 'if user location save fails or if user address is invalid rollback user save' do
      begin
        user = User.create(email: 'test3@gmail.com', password: '123456', address: 'Chennai, Ireland')
        # clean up and raise error to avoid future failures
        UserLocationInfo.find_by(user_id: user.id).delete
        User.destroy(user.id)
        raise 'test failed'
      rescue => e
        expect(e.message).to eq('invalid user address entered')
      end
    end
  end
end
