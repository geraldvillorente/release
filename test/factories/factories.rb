FactoryGirl.define do
  factory :release do
    start_at { Time.now.beginning_of_hour }
    end_at { Time.now.beginning_of_hour+30.minutes }
    user
  end

  factory :application do
    sequence(:name) {|n| "Application #{n}"}
    sequence(:repo) {|n| "alphagov/application-#{n}" }
    domain "mygithub.tld"
  end

  factory :deployment do
    sequence(:version) { |n| "release_#{n}" }
    environment "production"
  end

  factory :user do
    name "Stub User"
    sequence(:email) {|n| "winston-#{n}@gov.uk" }
    permissions { ["signin"] }
  end
end
