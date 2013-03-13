# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :room do
    title "MyString"
    state 1
    win 1
    cur_seat_id 1
    score 1
  end
end
