# == Schema Information
#
# Table name: notebooks
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  color               :string(255)
#  paper_type          :string(255)
#  carrier_identifier  :string(255)
#  user_id             :integer
#  meta                :hstore           default({}), not null
#  created_at          :datetime
#  updated_at          :datetime
#  notebook_identifier :string(255)
#  pdf                 :string(255)
#  pages_count         :integer          default(0)
#  deleted_at          :datetime
#  handle_method       :string(255)
#  state               :string(255)
#  submitted_on        :datetime
#  received_on         :datetime
#  uploaded_on         :datetime
#  processed_on        :datetime
#  returned_on         :datetime
#  recycled_on         :datetime
#  available_on        :datetime
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
      it { should validate_presence_of(:color) }
      it { should_not allow_value("100", "99", "xy", "abc", "").for(:color) }
    end

    describe "paper_type" do
      it { should allow_value(*Notebook::PAPER_TYPES.values).for(:paper_type) }
      it { should validate_presence_of(:paper_type) }
      it { should_not allow_value("100", "99", "xy", "abc", "").for(:paper_type) }
    end

    describe "carrier_identifier" do
      it { should allow_value("1234").for(:carrier_identifier) }
      it { should validate_presence_of(:carrier_identifier) }
      it { should validate_uniqueness_of(:carrier_identifier).case_insensitive }
    end

    describe "notebook_identifier" do
      it { should allow_value("02-01-1234").for(:notebook_identifier) }
      it { should validate_presence_of(:notebook_identifier) }
      it { should_not allow_value("0201-1234", "02011234").for(:notebook_identifier) }
      it { should validate_uniqueness_of(:notebook_identifier).case_insensitive }
    end

    describe "pdf_secure_token" do
      it { should_not allow_value("").for(:pdf_secure_token) }
    end
  end

  context "with a newly created notebook" do
    let(:notebook) { create(:notebook) }
    subject { notebook }

    describe "#current_state" do
      it "has a default state of submitted" do
        notebook.current_state.submitted?.should be
      end
    end

    describe '#process' do
      it "cannot be processed" do
        notebook.process.should be_nil
      end
    end

    describe "#upload" do
      it "can be uploaded" do
        notebook.upload.should be
        expect(notebook.uploaded?).to eq(true)
      end
    end
  end

end
