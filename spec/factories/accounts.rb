FactoryBot.define do
  factory :account do
    sequence(:name) { |n| "Account #{n}" }
    description { "Test account description" }
    status { 'active' }
    plan { 'trial' }
    plan_expires_at { 1.month.from_now }
    max_users { 3 }
    max_workspaces { 1 }

    association :owner, factory: :user
  end
end
