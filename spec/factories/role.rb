FactoryGirl.define do
  factory :role do
    role "administrator"
    association :user, factory: :user
  end
end
