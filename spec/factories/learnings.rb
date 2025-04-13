# spec/factories/learnings.rb
FactoryBot.define do
  factory :learning do
    # Reason: Use sequence to ensure unique titles for multiple factory calls.
    sequence(:title) { |n| "Learning Title #{n}" }
    body { "This is the body of the learning entry." }
    # Reason: Simple default, can be overridden in tests.
    learned_on { Date.today }
    # Reason: Include some default tags for testing filtering.
    tags { "rails, ruby, testing" }
  end
end