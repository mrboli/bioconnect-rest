FactoryGirl.define do
  factory :time_entry do
    time  Time.now
    timecard
  end
end

