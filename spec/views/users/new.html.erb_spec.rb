require 'rails_helper'

RSpec.describe "users/new", type: :view do
  it "sholud display a register form" do
    assign :user, User.new
    render
    
    expect(rendered).to match /Registration/
    expect(rendered).to match /Email/
    expect(rendered).to match /Username/
    expect(rendered).to match /Password/
    expect(rendered).to match /Password confirmation/
    expect(rendered).to match /Register/
  end
end
