require "spec_helper"

RSpec.describe Api::V1::TimeEntriesController , :type => :controller do
  describe "#index" do
    context "when no time entries" do
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

    context "when exists 10 time entries" do
      it "returns 200 OK" do
        create_list(:time_entry, 10)
        get :index
        expect(response).to be_success
      end

      it "returns 200 with 10 time entries" do
        create_list(:time_entry, 10)
        get :index
        parsed_json = JSON.parse(response.body)
        expect(parsed_json.count).to eq 10
      end
    end
  end

  describe "#show" do
    context "when an existing id is used" do
      let(:time_entry) { FactoryGirl.create :time_entry }

      it "returns 200 OK" do
        get :show, params: { id: time_entry }
        expect(response).to be_success        
      end

      it "returns data of a time_entry" do
        get :show, params: { id: time_entry }
        parsed_json = JSON.parse(response.body)
        expect(parsed_json).to_not be_nil
      end

      # TODO Validate json shcema / data returned is correct
    end

    # ASSUMPTION: in this new context block, there are no time entries
    context "when a non existant id is used" do
      it "returns 404 Not Found" do
        get :show, params: { id: 1 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "#create" do 
    context "when using valid time_entry params" do
      let (:timecard) { FactoryGirl.create :timecard }
      let (:time_entry_params) { 
        FactoryGirl.attributes_for(:time_entry).merge({ timecard_id: timecard })
      }

      it "returns 200" do
        post :create, params: { time_entry: time_entry_params }
        expect(response).to be_success
      end

      # ASSUMPTION: Successful post request returns created object
      it "returns a time_entry" do
        post :create, params: { time_entry: time_entry_params }
        parsed_json = JSON.parse(response.body)
        expect(parsed_json).to_not be_nil
      end
    end

    context "when using inavlid time_entry params" do
      pending
      #it "returns 422 Unprocessable Entity" do
      #end
    end

    context "when using invalid time_entry params" do
      # TODO: Model validations to fail params
      pending
    end
  end

  describe "#update" do
    context "when using an existing time entry" do
      context "when using valid params" do
        let (:time_entry) { FactoryGirl.create :time_entry }
        let (:time_entry_params) {{
          :time => DateTime.new
        }}

        it "returns 200 OK" do
          put :update, params: { id: time_entry, time_entry: time_entry_params }
          expect(response).to be_success
        end

        it "returns json" do
          put :update, params: { id: time_entry, time_entry: time_entry_params }
          parsed_json = JSON.parse(response.body)
          expect(parsed_json).to_not be_nil
        end
      end
      
      context "when using invalid params" do
        pending
      end
    end

    context "when using no time entry" do
      let (:time_entry_params) {{
        :time => DateTime.new
      }}

      it "returns 422 Unprocessable Entity" do
        put :update, params: { id: 1, time_entry: time_entry_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "#destroy" do
    context "when using an existing time entry" do
      let (:time_entry) { FactoryGirl.create :time_entry }

      it "returns 200 OK" do
        delete :destroy, params: { id: time_entry }
        expect(response).to be_success
      end
    end

    context "when using a time entry id that doesn't exist" do
      it "returns 422 Unprocessable Entity" do
        delete :destroy, params: { id: 1 }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end  

