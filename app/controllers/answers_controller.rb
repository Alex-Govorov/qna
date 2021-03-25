class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(@question), notice: t('.answer_created')
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: t('.answer_deleted')
    else
      redirect_to question_path(@answer.question), notice: t('.only_own_answer_can_be_deleted')
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
