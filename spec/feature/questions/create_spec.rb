require 'rails_helper'

feature 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  scenario 'Authenticated user asks a question'
  scenario 'Authenticated user asks a question with errors'
  scenario 'Unauthenticated user tried to ask a question'
end
