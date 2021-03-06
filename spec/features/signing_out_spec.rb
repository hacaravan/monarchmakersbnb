feature 'sign out' do
  scenario 'user can sign out' do
    create_user_and_sign_in

    click_button("Log out")
    expect(current_path).to eq('/listings')
    expect(page).not_to have_content('Hi test@test.com')
    expect(page).not_to have_content('name')
    expect(page).not_to have_button("Log out")
    expect(page).not_to have_button("Add Listing")

  end
end
