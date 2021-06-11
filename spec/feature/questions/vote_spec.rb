require 'rails_helper'

feature 'Authenticated user can vote for question he likes', "
In order to vote for liked resource
As an authenticated user
I'd like to be able to vote
" do
  it_behaves_like "votable", "question"
end
