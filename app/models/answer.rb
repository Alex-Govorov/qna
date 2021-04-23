class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  scope :sort_by_best, -> { order(best: :desc) }

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: -> { best }

  def mark_as_best
    transaction do
      # rubocop:disable Rails/SkipsModelValidations
      self.class.where(question_id: question_id).update_all(best: false)
      # rubocop:enable Rails/SkipsModelValidations
      # self.class.where(question_id: question_id).find_each { |answer| answer.update(best: false) }
      update(best: true)
    end
  end
end
