FactoryGirl.define do
  factory :user do
    name { Forgery::Name.first_name }
    email { Forgery::Internet.email_address }
  end
end
