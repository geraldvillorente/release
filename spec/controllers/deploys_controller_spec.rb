require 'spec_helper'

describe DeploysController do
  let(:application) { Application.new(name: "dummy", repo: "somerepo.com") }
  let(:deploy) { application.deploys.build(version: "release_101") }

  before do
    application.save
    deploy.save
  end

  describe "index" do
    before(:each) do
      get :index
    end

    it "should load successfully" do
      response.code.should eq("200")
    end

    it "should load the 'index' template" do
      response.should render_template("index")
    end
  end

  describe "show" do
    before(:each) do
      get :show, id: deploy.id
    end

    it "should load successfully" do
      response.code.should eq("200")
    end

    it "should load the 'show' template" do
      response.should render_template("show")
    end
  end

  describe "new" do
    before(:each) do
      get :new, application_id: application.id
    end

    it "should load successfully" do
      response.code.should eq("200")
    end

    it "should load the 'new' template" do
      response.should render_template("new")
    end
  end

  describe "edit" do
    describe "a non-existant Deploy record" do
      before(:each) do
        get :edit, id: 10000000000
      end

      it "should have a status of 404" do
        response.code.should eq("404")
      end
    end

    describe "an existing Deploy record" do
      before(:each) do
        get :edit, id: deploy.id
      end

      it "should have a status of 200" do
        response.code.should eq("200")
      end

      it "should load the 'edit' template" do
        response.should render_template("edit")
      end
    end
  end

  describe "create" do
    describe "post request without a body" do
      before(:each) do
        post :create
      end

      it "should 404 as we don't have an application id" do
        response.body.should eq("404 error")
      end
    end

    describe "post request with a body" do
      before(:each) do
        post :create, { application_id: deploy.application.id, deploy: { version: "release_a_bajillion" }}
      end

      it "should redirect to the 'show' action" do
        response.code.should eq("302")
        response.should redirect_to(action: "show", id: "2")
      end
    end
  end

  describe "update" do
    describe "post request with a non-existent id" do
      before(:each) do
        put :update, id: 1000000000, deploy: { version: "do_not_read_me" }
      end

      it "should show a 404" do
        response.code.should eq("404")
      end
    end

    describe "post request with a specific id" do
      before(:each) do
        put :update, id: deploy.id, deploy: { release: "release_some_version" }
      end

      it "should redirect to the show page" do
        response.code.should eq("302")
        response.should redirect_to(action: "show", id: deploy.id)
      end
    end
  end
end
