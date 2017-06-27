require "rails_helper"

RSpec.describe User, type: :model do
  context "associations" do
    it do
      is_expected.to have_many :posts
      is_expected.to have_many :comments
      is_expected.to have_many :active_relationships
      is_expected.to have_many :passive_relationships
      is_expected.to have_many :following
      is_expected.to have_many :followers
    end
  end
  context "validates" do
    it do
      is_expected.to validate_presence_of :full_name
      is_expected.to validate_presence_of :email
      is_expected.to validate_presence_of :password
    end
  end
end
