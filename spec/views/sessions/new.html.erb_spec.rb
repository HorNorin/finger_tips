require 'rails_helper'

RSpec.describe "sessions/new", type: :view do
  it "should display a login form" do
    assign :user, User.new
    render
    
    expect(rendered).to match /Login to Fingertips/
    expect(rendered).to match /Email/
    expect(rendered).to match /Password/
    expect(rendered).to match /Login/
    expect(rendered).to match /Remember me/
    expect(rendered).to match /Forgot your password?/
  end
end
