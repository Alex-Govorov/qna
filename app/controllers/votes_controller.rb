class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_params

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  def vote_reset
    vote = Vote.find_by(@params)
    vote.destroy
    vote_status
  end

  # У меня вся логика голосования описана в модели через валидации.
  # Чтобы не писать методы дублирующие валидацию,
  # я создаю новый объект и формирую данные по результатам валидации.
  # Корректно ли использовать такую технику?

  def vote_status
    vote = Vote.new(@params)
    @params[:can_vote] = vote.valid?
    @params[:can_reset] = vote.errors[:user].include?('already voted for this resourse')
    @params[:score] = vote.votable.votes.score
    render json: @params.except(:user)
  end

  private

  def vote(value)
    vote = Vote.new(@params)
    vote.value = value
    if vote.save(context: :vote)
      vote_status
    else
      render json: vote.errors.full_messages, status: :unprocessable_entity
    end
  end

  def set_params
    @params = { votable_type: params[:resource_type], votable_id: params[:resource_id],
                user: current_user }
  end
end
