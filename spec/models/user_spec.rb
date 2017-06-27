require 'rails_helper'

RSpec.describe User, type: :model do
  context "associations" do
    it {is_expected.to have_many :posts}
    it {is_expected.to have_many :comments}
    it {is_expected.to have_many :active_relationships}
    it {is_expected.to have_many :passive_relationships}
    it {is_expected.to have_many :following}
    it {is_expected.to have_many :followers}
  end
end
