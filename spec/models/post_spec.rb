require "rails_helper"

RSpec.describe Post, type: :model do
  context "associations" do
    it do
      is_expected.to have_many :tags
      is_expected.to belong_to :user
      is_expected.to have_many :post_tags
      is_expected.to have_many :tags
    end
  end
  context "validates" do
    it do
      is_expected.to validate_presence_of :title
      is_expected.to validate_presence_of :content
      is_expected.to validate_length_of(:title)
        .is_at_most(Settings.post.title.max_length)
    end
  end
end
