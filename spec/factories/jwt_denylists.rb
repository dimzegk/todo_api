FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2025-09-13 11:59:01" }
  end
end
