feature 'display bookings' do
  scenario "display guest's confirmed bookings" do
    make_request
    click_button('Log Out')
    login_as_host
    click_link('Requests')
    first('.requests-received').click_button('Confirm Booking')
    click_link('Dashboard')
    click_button('Log Out')
    fill_in('email', with: 'm.spencer@makers.com')
    fill_in('password', with: '2020')
    click_button('Login')
    click_link('Bookings')

    expect(page).to have_content('2019-07-17')
  end

  scenario 'display bookings that the host has confirmed' do
    make_request
    click_button('Log Out')
    login_as_host
    click_link('Requests')
    first('.requests-received').click_button('Confirm Booking')
    click_link('Dashboard')
    click_link('Bookings')
    
    expect(page).to have_content('2019-07-17')
  end
end
