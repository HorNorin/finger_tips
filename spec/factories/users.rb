FactoryGirl.define do
  factory :user do
    sequence(:username) { |i| "norin#{i+1}" }
    sequence(:email) { |i| "norin#{i+1}@example.com" }
    password "secret"
    password_confirmation "secret"
  end
end
