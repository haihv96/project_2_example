require "rails_helper"

RSpec.describe Tag, type: :model do
  context "associations" do
    it do
      is_expected.to have_many :post_tags
      is_expected.to have_many :posts
    end
  end
  context "validates" do
    it do
      is_expected.to validate_presence_of :name
    end
  end
end
