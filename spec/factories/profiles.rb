# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    user nil
    pin 1
    residence "MyString"
    citizenship "MyString"
  end
end
