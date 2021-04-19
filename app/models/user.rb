class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(resource)
    # resource.user == self
    # Я так и не понял, как воспроизвести проблему n+1
    # Подробный вопрос оставил тут: https://github.com/Alex-Govorov/qna/pull/3#discussion_r601611787
    resource.user_id == id
  end
end
