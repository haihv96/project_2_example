require "rails_helper"

RSpec.describe PostTag, type: :model do
  context "associations" do
    it do
      is_expected.to belong_to :post
      is_expected.to belong_to :tag
    end
  end
  context "validates" do
    it do
      is_expected.to validate_presence_of :post
      is_expected.to validate_presence_of :tag
    end
  end
end
