class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy edit update mark_as_best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def destroy
    return head :forbidden unless current_user.author_of?(@answer)

    @answer.destroy
  end

  def edit; end

  def update
    return head :forbidden unless current_user.author_of?(@answer)

    @answer.update(answer_params)
  end

  def mark_as_best
    return head :forbidden unless current_user.author_of?(@answer.question)

    @answer.mark_as_best
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
