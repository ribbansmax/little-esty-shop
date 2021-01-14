require 'rails_helper'
require 'singleton'

RSpec.describe "ApiSearch" do
  before :each do 
    @api = ApiSearch.instance
  end
  it "is a search class" do
    expect(@api).to be_a ApiSearch
  end

  describe "instance methods" do 
    it "repo_name" do 
      expect(@api.repo_name).to be_a String
      expect(@api.repo_name).to eq("little-esty-shop")   
    end

    it "contributors" do 
      expect(@api.contributors).to be_a Array
    end

    it "merged_pull_request" do   
      expect(@api.merged_pull_request).to be_a Integer
    end
  end
end