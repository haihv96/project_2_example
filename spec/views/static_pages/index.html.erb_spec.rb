require "rails_helper"

RSpec.describe "static_pages/index", type: :view do
  before :each do
    user = FactoryGirl.create :user, full_name: :test, password: 123456,
      email: "a@gmail.com"

    allow(view).to receive(:current_user).and_return user
    allow(view).to receive(:user_signed_in?).and_return user
  end

  it "display index" do
    render
    expect(rendered).to have_tag "div"
  end
end
