FactoryBot.define do
  factory :todo_item do
    name { 'Task 1' }
    done { false }
    association :todo
  end
end
