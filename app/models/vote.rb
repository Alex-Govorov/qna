class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true
  delegate :user_id, to: :votable, prefix: true

  validates :value, presence: true, inclusion: { in: [-1, 1] }, on: :vote
  validates :user_id, numericality: { other_than: :votable_user_id,
                                      message: "can't vote for own resource" }
  validates :user, uniqueness: { scope: %i[votable_type votable_id],
                                 message: 'already voted for this resourse' }

  def self.score
    sum(:value)
  end
end
