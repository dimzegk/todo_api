FactoryBot.define do
  factory :todo do
    title { 'My List' }
    association :user
  end
end
