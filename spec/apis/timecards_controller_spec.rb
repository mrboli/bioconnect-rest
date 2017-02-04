require "spec_helper"

RSpec.describe Api::V1::TimecardsController , :type => :controller do
  it "shows list of timecards" do
    get :index
    expect(response.status).to eq(200)
  end
end  
