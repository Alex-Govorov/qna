class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :votable
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  scope :sort_by_best, -> { order(best: :desc) }

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: -> { best }

  def mark_as_best
    transaction do
      # rubocop:disable Rails/SkipsModelValidations
      question.answers.update_all(best: false)
      # rubocop:enable Rails/SkipsModelValidations
      update!(best: true)
      question&.reward&.update!(user: user)
    end
  end
end
