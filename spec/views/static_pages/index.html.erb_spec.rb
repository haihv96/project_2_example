require "rails_helper"

RSpec.describe "static_pages/index", type: :view do
  it "display index" do
    render
    expect(rendered).to have_tag "div"
  end
end
