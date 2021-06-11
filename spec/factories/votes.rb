FactoryBot.define do
  factory :vote do
    value { 1 }
    user
    for_question

    trait :for_question do
      association(:votable, factory: :question)
    end

    trait :for_answer do
      association(:votable, factory: :answer)
    end
  end
end
