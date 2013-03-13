# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :seat do
    seat_id 1
    room_id 1
    user_id 1
    state 1
    score 1
    poker "MyString"
  end
end
