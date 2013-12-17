# == Schema Information
#
# Table name: notebooks
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  color              :string(255)
#  paper_type         :string(255)
#  carrier_identifier :string(255)
#  user_id            :integer
#  meta               :hstore
#  created_at         :datetime
#  updated_at         :datetime
#

# spec/models/notebook_spec.rb
require 'spec_helper'

describe Notebook do
  context "associations" do
    it { should belong_to(:user) }
    it { should have_many(:events) }
  end

  context "validations" do
    describe "color" do
      it { should allow_value(*Notebook::COLORS.values).for(:color) }
      it { should_not allow_value("100", "99", "xy", "abc", "").for(:color) }
    end

    describe "paper_type" do
      it { should allow_value(*Notebook::PAPER_TYPES.values).for(:paper_type) }
      it { should_not allow_value("100", "99", "xy", "abc", "").for(:paper_type) }
    end

    describe "carrier_identifier" do
      it { should allow_value("1234").for(:carrier_identifier) }
      it { should validate_uniqueness_of(:carrier_identifier).case_insensitive }
    end
  end

  context "with a newly created notebook" do
    let(:notebook) { create(:notebook) }
    subject { notebook }

    describe "#current_state" do
      it "has a default state of :with_user" do
        notebook.current_state.with_user?.should be
      end
    end

    describe "#upload" do
      it "cannot be uploaded" do
        notebook.upload.should be_nil
      end
    end

    describe '#process' do
      it "cannot be processed" do
        notebook.process.should be_nil
      end
    end

    describe "#submit" do
      it "can be submitted" do
        notebook.submit
        expect(notebook.submitted?).to eq(true)
      end
    end
  end

end