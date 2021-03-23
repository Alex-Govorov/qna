class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def new
    @question = Question.new
  end

  def show
    @question = Question.find(params[:id])
  end

  def create
    @question = Question.create(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def index
    @questions = Question.all
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
