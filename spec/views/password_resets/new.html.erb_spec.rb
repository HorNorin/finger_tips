require 'rails_helper'

RSpec.describe "password_resets/new", type: :view do
  it "should render a form" do
    render 
    
    expect(rendered).to match /Password Reset/
    expect(rendered).to match /Email/
    expect(rendered).to match /Reset/
  end
end
