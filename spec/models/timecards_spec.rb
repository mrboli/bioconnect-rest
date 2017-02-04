require 'spec_helper'

RSpec.describe Timecard, :type => :model do

  describe "#update_total_time" do
    context "with 1 or less time entries" do
      subject(:timecard) { FactoryGirl.create :timecard, :with_time_entries, amount: 1 }

      it "should stay as nil" do
        timecard.update_total_time
        expect(timecard.total_time).to be_nil
      end
    end

    context "with 2 or more time entries" do
      context "when both have current datetimes" do
        subject(:timecard) {
          FactoryGirl.create(
            :timecard,
            :with_time_entries,
            amount: 2
          )
        }

        it "should have a value" do
          timecard.update_total_time
          expect(timecard.total_time).to be_a_kind_of(Numeric)
        end
      end
      
      context "when the date times are 2 weeks apart and reversed in order" do
        let(:timediff) { 2.weeks.to_i }
        let(:datetimes) {[
          Time.now,
          Time.now - timediff
        ]}

        subject(:timecard) {
          FactoryGirl.create(
            :timecard,
            :with_time_entries,
            amount: 2,
            datetimes: datetimes
          )
        }

        it "should have a 2 week time difference" do
          timecard.update_total_time
          total_time_conv = timecard.total_time / 1.days
          final_difference = total_time_conv - timediff
          # There's a calculation issue from date conversion approximate that needs a buffer
          expect(final_difference.abs).to be <= 1
        end
      end

      context "when the date times are 5 years apart and reversed in order" do
        let(:timediff) { 5.years.to_i }
        let(:datetimes) {[
          Time.now,
          Time.now - timediff
        ]}

        subject(:timecard) {
          FactoryGirl.create(
            :timecard,
            :with_time_entries,
            amount: 2,
            datetimes: datetimes
          )
        }

        it "should have a 2 week time difference" do
          timecard.update_total_time
          total_time_conv = timecard.total_time / 1.days
          final_difference = total_time_conv - timediff
          # There's a calculation issue from date conversion approximate that needs a buffer
          expect(final_difference.abs).to be <= 1
        end
      end
    end

    context "with 3 or more dates" do
      pending
    end
  end
end
