# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Basic setup', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, owner: user) }

  before do
    sign_in user
  end

  it 'can access the home page' do
    get root_path
    expect(response).to have_http_status(:success)
    expect(response.body).to include('Here')
  end
end
