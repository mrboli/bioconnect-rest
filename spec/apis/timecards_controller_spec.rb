require "spec_helper"

RSpec.describe Api::V1::TimecardsController , :type => :controller do
  describe "#index" do
    it "responds with 200" do
      get :index
      expect(response).to be_success
    end

    context "when no timecards" do
      it "returns 200" do
        get :index
        expect(response).to be_success
      end

      it "returns an empty list" do
        get :index
        parsed_json = JSON.parse(response.body)
        expect(parsed_json).to eq([])
      end
    end

    context "when exists 10 timecards" do
      it "returns 200 OK" do
        create_list(:timecard, 10)
        get :index
        expect(response).to be_success
      end

      it "returns 200 with 10 timecards" do
        create_list(:timecard, 10)
        get :index
        parsed_json = JSON.parse(response.body)
        expect(parsed_json.count).to eq 10
      end
    end
  end

  describe "#show" do
    context "when an existing id is used" do
      let(:timecard) { FactoryGirl.create :timecard }

      it "returns 200 OK" do
        get :show, params: { id: timecard }
        expect(response).to be_success        
      end

      it "returns data of a timecard" do
        get :show, params: { id: timecard }
        parsed_json = JSON.parse(response.body)
        expect(parsed_json).to_not be_nil
      end

      # TODO Validate json shcema / data returned is correct
      #it "returns the correct timecard data" do
        #pending
      #end
    end

    # ASSUMPTION: in this new context block, there are no timecards
    context "when a non existing id is used" do
      it "returns 422 Unprocessable Entity" do
        get :show, params: { id: 1 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "#create" do 
    context "when using valid timecard params" do
      let (:timecard_params) { FactoryGirl.attributes_for :timecard }

      # ASSUMPTION: Successful post request return created object
      it "returns 200" do
        post :create, params: { timecard: timecard_params }
        expect(response).to be_success
      end

      it "returns a timecard" do
        post :create, params: { timecard: timecard_params }
        parsed_json = JSON.parse(response.body)
        expect(parsed_json).to_not be_nil
      end

      #it "returns the correct timecard data" do
        #pending
      #end
    end

    context "when an unexisting timecard id is used" do
      it "returns 422 Unprocessable Entity" do
      end
    end

    context "when using invalid timecard params" do
      # TODO: Model validations to fail params
      pending
    end
  end
end  
