FactoryGirl.define do
  factory :checklist do
    sequence(:filename) { |n| "checklist-#{n}.csv" }
    token { Gnc.token }
    after(:build) { |checklist| checklist_file(checklist.token) }
  end
end
