require 'spec_helper'

describe Api::V1::NotebooksController do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "without a user" do
    describe "GET #index" do
      before { get :index }
      it { should respond_with(:not_found) }
    end

    describe "GET #show" do
      let(:notebook) { create(:notebook) }
      before { get :show, id: notebook.id }
      it { should respond_with(:not_found) }
    end

    describe "POST #create" do
      let(:notebook) { build(:notebook) }
      before { post :create, notebook: { notebook_identifier: notebook.notebook_identifier } }
      it { should respond_with(:not_found) }
    end

    describe "PUT #update" do
      let(:notebook) { create(:notebook) }
      before { put :update, id: notebook.id, notebook: { name: "New Name" } }
      it { should respond_with(:not_found) }
    end
  end

  context "with a user" do
    let(:user) do
      user = create(:user)
      user.confirm!
      user
    end

    before :each do
      request.headers['Authorization'] = "#{user.email}:#{user.authentication_token}"
    end

    describe "GET #index with no notebooks" do
      before { get :index, format: :json }
      let(:body) { JSON.parse(response.body) }

      it { should respond_with(:ok) }

      it "should return an array" do
        body.should_not be_nil
        body.should be_an(Array)
      end
    end

    describe "GET #index with notebooks" do
      let!(:my_notebook) { create(:notebook, user: user) }
      let!(:their_notebook) { create(:notebook) }

      before { get :index, format: :json }
      let(:body) { JSON.parse(response.body) }

      it { should respond_with(:ok) }

      it "should return an array" do
        body.should_not be_nil
        body.should be_an(Array)
      end

      it "should only return my notebooks" do
        body.count.should eq(1)
        body.first['id'].should eq(my_notebook.id)
      end
    end
  end

end
