ENV["RAILS_ENV"] = "test"

require File.expand_path('../../config/environment', __FILE__)
require "mocha/setup"
require 'rails/test_help'
require 'shoulda-context'
require_relative '../spec/support/factories'

class ActiveSupport::TestCase
  def stub_user
    @stub_user ||= FactoryGirl.create(:user, :name => 'Stub User')
  end

  def login_as_stub_user
    login_as stub_user
  end

  def login_as(user)
    request.env['warden'] = stub(
      :authenticate! => true,
      :authenticated? => true,
      :user => user
    )
  end
end