# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factory' do
    it { expect { create(:user) }.not_to raise_error }
    it { expect { create(:user) }.to change { User.count }.by 1 }
  end
end
