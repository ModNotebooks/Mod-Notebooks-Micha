# spec/models/notebook_spec.rb
require 'spec_helper'

describe Notebook do
  it "should have valid factory" do
    build(:notebook).should be_valid
  end
end
