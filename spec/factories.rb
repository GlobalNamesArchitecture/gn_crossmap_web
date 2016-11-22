# frozen_string_literal: true

FactoryGirl.define do
  factory :crossmap do
    sequence(:filename) { |n| "nameslist-#{n}.csv" }
    token { Gnc.token }
    input { Crossmap.input(token) }
    output { Crossmap.output(token, filename) }
    after(:build) { |crossmap| name_list_file(crossmap.token) }
  end
end
