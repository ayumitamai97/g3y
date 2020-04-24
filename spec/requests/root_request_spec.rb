# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Roots', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      skip 'skip'
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
