require "test_helper"

class ReleasesControllerTest < ActionController::TestCase
  setup do
    login_as_stub_user
  end

  context "GET index" do

  end

  context "GET new" do
    should "render the form" do
      get :new
      assert_template "releases/new"
    end
  end

  context "POST create" do
    setup do
      @app = FactoryGirl.create(:application)
    end

    should "create a release" do
      assert_difference "Release.count", 1 do
        post :create, release: { }
      end
    end

    should "create the release as the signed in user" do
      assert_difference "Release.count", 1 do
        post :create, release: { }
      end

      release = Release.first
      assert_equal stub_user.name, release.user.name
    end
  end

  context "GET show" do
    setup do
      @release = FactoryGirl.create(:release)
    end

    should "show the release" do
      get :show, id: @release.id
      assert_select "h1", "Release #{@release.id}"
    end
  end

  context "GET edit" do
    setup do
      @release = FactoryGirl.create(:release)
    end

    should "show the form" do
      get :edit, id: @release.id
      assert_template "releases/edit"
    end
  end

  context "PUT update" do
    setup do
      @release = FactoryGirl.create(:release)
    end

    should "update the release" do
      put :update, id: @release.id, release: { }
      @release.reload
    end
  end
end
