require "spec_helper"

RSpec.describe Api::V1::TimecardsController , :type => :controller do
  describe "#index" do
    it "responds with 200" do
      get :index
      expect(response).to be_success
    end

    context "when no timecards" do
      it "returns 200 with an empty list" do
        get :index
        expect(response).to be_success
        expect(json).to eq([])
      end
    end

    context "when exists 10 timecards" do
      it "returns 200 with 10 timecards" do
        create_list(:timecard, 10)
        get :index
        expect(response).to be_success
        expect(json.count).to eq 10
      end
    end
  end
end  
