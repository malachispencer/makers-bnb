# frozen_string_literal: true

feature 'displaying spaces on MakersBnB' do
  let(:test_user) { User.create(name: 'Jane Doe', email: 'jane_doe@gmail.com', password: '12345qwerty') }

  scenario "displays 'Makers BnB Spaces' on /listings route" do
    login_to_dashboard
    click_link('here')

    expect(page).to have_content('MakersBnB Spaces')
  end

  scenario 'display the listings list on /listings route' do
    Space.create(
      description: 'A luxurious villa in Beverly Hills',
      name: 'Hidden Gem of Beverly Hills',
      location: 'Los Angeles, Beverly Hills',
      price: 300,
      user_id: test_user.id
    )

    login_to_dashboard
    click_link('here')

    expect(page).to have_content('Hidden Gem of Beverly Hills')
    expect(page).to have_content('A luxurious villa in Beverly Hills')
    expect(page).to have_content('Los Angeles, Beverly Hills')
    expect(page).to have_content('300')
    expect(page).to have_content(test_user.name)
  end

  scenario 'user can view all listings if no date is chosen' do
    Space.create(description: 'A luxurious villa in Beverly Hills', name: 'Hidden Gem of Beverly Hills',
                 location: 'Los Angeles, Beverly Hills', price: 300, user_id: test_user.id)
    login_to_dashboard
    click_link('here')

    expect(page).to have_content('Hidden Gem of Beverly Hills')
    expect(page).to have_content('A luxurious villa in Beverly Hills')
    expect(page).to have_content('Los Angeles, Beverly Hills')
    expect(page).to have_content('300')
  end

  scenario 'the user can choose a date by either typing it in or via the calendar' do
    Space.create(description: 'A luxurious villa in Beverly Hills', name: 'Hidden Gem of Beverly Hills',
                 location: 'Los Angeles, Beverly Hills', price: 300, user_id: test_user.id)
    new_space = Space.create(description: 'New York Mansion in Manhattan', name: 'New York Gem',
                             location: 'New York, Manhattan', price: 1000, user_id: test_user.id)
    random_date = Date.today.to_s
    Booking.create(check_in: random_date, booked: true, space_id: new_space.id, user_id: new_space.user_id)
    login_to_dashboard
    fill_in('check_in_date', with: '07/17/2019 12:00 AM')
    click_button('Search Properties')

    expect(page).to have_content('New York Mansion in Manhattan')
    expect(page).to have_content('New York Gem')
    expect(page).to have_content('New York, Manhattan')
    expect(page).to have_content('1000')
  end
end
