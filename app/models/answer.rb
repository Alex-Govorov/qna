class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  scope :sort_by_best, -> { order(best: :desc) }

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: -> { best }

  def mark_as_best
    transaction do
      # rubocop:disable Rails/SkipsModelValidations
      question.answers.update_all(best: false)
      # rubocop:enable Rails/SkipsModelValidations
      update!(best: true)
    end
  end
end
