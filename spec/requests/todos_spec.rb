require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_header_for(user) }

  it 'lists todos' do
    create_list(:todo, 2, user: user)
    get '/todos', headers: headers
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).size).to eq(2)
  end

  it 'creates, shows, updates, deletes a todo' do
    post '/todos', params: { todo: { title: 'Groceries' } }, headers: headers
    expect(response).to have_http_status(:created)
    id = JSON.parse(response.body)['id']

    get "/todos/#{id}", headers: headers
    expect(response).to have_http_status(:ok)

    put "/todos/#{id}", params: { todo: { title: 'New Title' } }, headers: headers
    expect(JSON.parse(response.body)['title']).to eq('New Title')

    delete "/todos/#{id}", headers: headers
    expect(response).to have_http_status(:no_content)
  end
end
