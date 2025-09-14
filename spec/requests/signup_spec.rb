require 'rails_helper'

RSpec.describe 'Signup', type: :request do
  it 'creates a user' do
    post '/signup', params: { user: { email: 'a@b.com', password: 'pass1234', password_confirmation: 'pass1234' } }
    expect(response).to have_http_status(:created)
    body = JSON.parse(response.body)
    expect(body['email']).to eq('a@b.com')
  end
end
