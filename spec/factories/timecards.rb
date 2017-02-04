FactoryGirl.define do
  factory :timecard do
    username    "testuser"
    occurrence  Time.now

    trait :with_time_entries do
      transient do
        amount 1
        datetimes []
      end

      after(:create) do |timecard, evaluator|
        datetimes = evaluator.datetimes
        evaluator.amount.times do |index|
          if datetimes.empty? || datetimes[index].blank?
            create :time_entry, timecard: timecard
          else
            create :time_entry, timecard: timecard, time: datetimes[index]
          end
        end
      end
    end
  end
end

