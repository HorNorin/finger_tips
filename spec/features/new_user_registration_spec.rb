require "rails_helper"

RSpec.feature "New user registration", type: :feature do
  scenario "Register with valid information" do
    visit register_path
    
    fill_in "Username", with: "norin"
    fill_in "Email", with: "norin@example.com"
    fill_in "Password", with: "secret"
    fill_in "Password confirmation", with: "secret"
    click_button "Register"
    
    text = <<-fin
        A confirmation email has been sent to norin@example.com.
        Please check your email address.
    fin
    expect(page).to have_text(text)
    expect(page).to have_css("div.alert-success")
  end
  
  scenario "Register with invalid information" do
    visit register_path
    
    fill_in "Username", with: "norin"
    fill_in "Email", with: "norin@example"
    fill_in "Password", with: "secret"
    fill_in "Password confirmation", with: "secret"
    click_button "Register"
    
    expect(page).to have_selector("ul.errors>li", count: 1)
  end
end
