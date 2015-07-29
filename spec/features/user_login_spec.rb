require "rails_helper"

RSpec.feature "User login", type: :feature do
  before(:each) do
    @user = FactoryGirl.create :user,
            username: "Norin",
            email: "norin@example.com",
            password: "secret",
            password_confirmation: "secret",
            account_activated: true
  end
  
  scenario "User login with valid credential" do
    visit login_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Login"
    
    expect(page).to have_text("Welcome, #{@user.username}!")
    expect(page).to have_css("div.alert-success")
  end
  
  scenario "Redirect user back to where they was when login successful" do
    visit lessons_path
    click_link "Login"
    
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Login"
    
    expect(current_path).to eq(lessons_path)
  end
  
  scenario "User login with invalid credential" do
    visit login_path
    fill_in "Email", with: "invalid@email.com"
    fill_in "Password", with: @user.password
    click_button "Login"
    
    expect(page).to have_field("Email", with: "invalid@email.com")
    expect(page).to have_text("Invalid email or password")
    expect(page).to have_css("div.alert-error")
  end
end
