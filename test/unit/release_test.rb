require "test_helper"

class ReleaseTest < ActiveSupport::TestCase


  context "creating a release" do
    setup do
      @atts = {
      }
    end

    context "given a user" do
      should "be created successfully" do
        user = FactoryGirl.create(:user)

        release = Release.new(@atts)
        assert release.valid?

        release.save_as(user)
        assert release.persisted?
      end

      should "persist the user" do
        user = FactoryGirl.create(:user)

        release = Release.new(@atts)
        release.save_as(user)

        release.reload
        assert_equal user, release.user
      end
    end

    context "given valid attributes" do
      should "be created successfully" do
        release = Release.new(@atts)
        assert release.valid?

        release.save
        assert release.persisted?
      end
    end
  end
end
