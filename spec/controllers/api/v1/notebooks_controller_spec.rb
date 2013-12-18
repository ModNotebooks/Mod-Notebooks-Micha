require 'spec_helper'

describe Api::V1::NotebooksController do

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

end
