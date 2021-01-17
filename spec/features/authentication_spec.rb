# frozen_string_literal: true

feature 'Authentication' do
  scenario 'User can login' do
    User.create(name: 'Alex', email: 'alex@alex.com', password: 'Alex123')
    visit '/'
    click_link 'Login'
    fill_in :email, with: 'alex@alex.com'
    fill_in :password, with: 'Alex123'
    click_button 'Login'

    expect(current_path).to eq '/dashboard'
    expect(page).to have_content 'Welcome, Alex'
  end

  scenario 'User gets error message when logging in with wrong email' do
    User.create(name: 'Alex', email: 'alex@alex.com', password: 'Alex123')
    visit '/'
    click_link 'Login'
    fill_in :email, with: 'balex@alex.com'
    fill_in :password, with: 'Alex123'
    click_button 'Login'

    expect(current_path).to eq '/sessions/new'
    expect(page).not_to have_content 'Welcome, Alex'
    expect(page).to have_content 'Login details incorrect - please try again'
  end

  scenario 'User gets error message when logging in with wrong password' do
    User.create(name: 'Alex', email: 'alex@alex.com', password: 'Alex123')
    visit '/'
    click_link 'Login'
    fill_in :email, with: 'alex@alex.com'
    fill_in :password, with: 'Balex123'
    click_button 'Login'

    expect(current_path).to eq '/sessions/new'
    expect(page).not_to have_content 'Welcome, Alex'
    expect(page).to have_content 'Login details incorrect - please try again'
  end

  scenario 'User is able to log out' do
    User.create(name: 'Alex', email: 'alex@alex.com', password: 'Alex123')
    visit '/'
    click_link 'Login'
    fill_in :email, with: 'alex@alex.com'
    fill_in :password, with: 'Alex123'
    click_button 'Login'

    click_button 'Log Out'

    expect(current_path).to eq('/sessions/new')
    expect(page).to have_content 'Succesfully Logged Out'
  end
end
