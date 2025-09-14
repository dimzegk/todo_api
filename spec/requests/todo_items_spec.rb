require 'rails_helper'

RSpec.describe 'TodoItems', type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_header_for(user) }
  let!(:todo) { create(:todo, user: user) }

  it 'creates, gets, updates and deletes an item' do
    post "/todos/#{todo.id}/items", params: { item: { name: 'Milk', done: false } }, headers: headers
    expect(response).to have_http_status(:created)
    iid = JSON.parse(response.body)['id']

    get "/todos/#{todo.id}/items/#{iid}", headers: headers
    expect(response).to have_http_status(:ok)

    put "/todos/#{todo.id}/items/#{iid}", params: { item: { done: true } }, headers: headers
    expect(JSON.parse(response.body)['done']).to eq(true)

    delete "/todos/#{todo.id}/items/#{iid}", headers: headers
    expect(response).to have_http_status(:no_content)
  end
end
