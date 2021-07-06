class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resource

  def create
    vote = @resource.votes.new(value: params[:value], user: current_user)
    if vote.save(context: :vote)
      show
    else
      render json: vote.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    vote = @resource.votes.find_by(user: current_user)
    vote.destroy
    show
  end

  def show
    vote = @resource.votes.new(value: 1, user: current_user)
    vote_response = {}
    vote_response[:resource_type] = @resource.class.to_s.downcase
    vote_response[:resource_id] = @resource.id
    vote_response[:can_vote] = vote.valid?
    vote_response[:can_reset] = vote.errors[:user].include?('already voted for this resourse')
    vote_response[:score] = @resource.votes.score
    render json: vote_response
  end

  private

  def set_resource
    param = params.select { |key| key.to_s.include?('_id') }
    resource = param.keys.first.to_s.split('_').first.singularize.classify.constantize
    resource_id = param.values.first
    @resource = resource.find(resource_id)
  end
end
