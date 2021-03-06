class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show destroy edit update]

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.build_reward
  end

  def show
    @answers = @question.answers.sort_by_best
    @answer = Answer.new
    @answer.links.new
  end

  def create
    @question = current_user.questions.create(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def index
    @questions = Question.all
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: t('.question_deleted')
    else
      redirect_to questions_path, notice: t('.only_own_question_can_be_deleted')
    end
  end

  def edit; end

  def update
    return head :forbidden unless current_user.author_of?(@question)

    @question.update(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[name url id _destroy],
                                                    reward_attributes: %i[title image])
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
