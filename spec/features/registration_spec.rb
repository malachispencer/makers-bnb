# frozen_string_literal: true

feature 'registration' do
  scenario 'user visits home and signs up' do
    visit('/')
    fill_in('name', with: 'Malachi')
    fill_in('email', with: 'm.spencer@makers.com')
    fill_in('password', with: 'p20201124')
    click_button('Submit')

    expect(current_path).to eq('/dashboard')
    expect(page).to have_content('Welcome, Malachi')
  end

  context 'users visits non-home page without logging in' do
    scenario 'gets redirected to login page' do
      visit('/listings')
      expect(current_path).to eq('/sessions/new')

      expect(page).to have_content('Login to Makers BnB')
      expect(page).to have_link('here', href: '/')
    end
  end
end
