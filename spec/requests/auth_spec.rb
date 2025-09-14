require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /auth/login' do
    let!(:user) { create(:user, password: 'secret', password_confirmation: 'secret') }

    it 'returns token with valid creds' do
      post '/auth/login', params: { email: user.email, password: 'secret' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key('token')
    end

    it 'rejects invalid creds' do
      post '/auth/login', params: { email: user.email, password: 'wrong' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /auth/logout' do
    let(:user) { create(:user) }
    it 'revokes token' do
      get '/auth/logout', headers: auth_header_for(user)
      expect(response).to have_http_status(:ok)
    end
  end
end
