def login_to_dashboard
  User.create(name: 'Malachi', email: 'm.spencer@makers.com', password: '2020')
  visit('/sessions/new')
  fill_in('email', with: 'm.spencer@makers.com')
  fill_in('password', with: '2020')
  click_button('Login')
end

def make_request
  host = User.create(name: 'Constantine', email: 'constantine@makers.com', password: '12345qwerty')
  Space.create(
    name: 'Hidden Gem of Beverly Hills',
    description: 'A luxurious villa in Beverly Hills',
    location: 'Los Angeles, Beverly Hills',
    price: 300,
    user_id: host.id
  )
  login_to_dashboard
  fill_in('check_in_date', with: '07/17/2019')
  click_button('Search Properties')
  first('.card').click_button('Request Space')
  click_link('dashboard')
end

def login_as_host
  visit('/sessions/new')
  fill_in('email', with: 'constantine@makers.com')
  fill_in('password', with: '12345qwerty')
  click_button('Login')
end
