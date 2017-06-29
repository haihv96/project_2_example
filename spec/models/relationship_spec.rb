require "rails_helper"

RSpec.describe Relationship, type: :model do
  context "associations" do
    it do
      is_expected.to belong_to :followed
      is_expected.to belong_to :follower
    end
  end
  context "validates" do
    it do
      is_expected.to validate_presence_of :followed
      is_expected.to validate_presence_of :follower
    end
  end
end
