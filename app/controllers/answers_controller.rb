class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[new create destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(@question), notice: t('.answer_created')
    else
      render :new
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if @answer.user == current_user
      @answer.destroy
      redirect_to question_path(@question), notice: t('.answer_deleted')
    else
      redirect_to question_path(@question), notice: t('.only_own_answer_can_be_deleted')
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end
end
