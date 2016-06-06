require 'rails_helper'

RSpec.feature "User can sign-up" do
  scenario "when a user fills in username, password and password-confirmation" do

    visit root_path

    click_on "Sign Up"

    expect(current_path).to eq new_user_registration_path

    save_and_open_page
    within(".sign-up") do
      fill_in :email, with: "pindell@example.com"
      fill_in :password, with: "password"
      fill_in :password_confirmation, with: "password"
    end

    expect(current_path).to eq root_path
    expect(User.first.email).to eq "pindell@example.com"

    within(".flash") do
      expect(page).to have_content "Welcome! You have signed up successfully."
    end
  end
end
