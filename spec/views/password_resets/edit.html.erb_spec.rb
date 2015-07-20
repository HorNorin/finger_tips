require 'rails_helper'

RSpec.describe "password_resets/edit", type: :view do
  it "should render a form" do
    assign :user, FactoryGirl.create(:user)
    render
    
    expect(rendered).to match /Password Reset/
    expect(rendered).to match /New Password/
    expect(rendered).to match /Confirm/
  end
end
