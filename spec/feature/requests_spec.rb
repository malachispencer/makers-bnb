# frozen_string_literal: true

feature 'Requests' do
  context 'Request link on dashboard' do
    scenario 'user clicks on request link' do
      login_to_dashboard
      click_link('Requests')
      expect(current_path).to eq('/requests')
      expect(page).to have_content('Requests')
    end
  end

  context 'all requests made are being displayed' do
    scenario 'user is able to view all requests made in /requests route' do
      make_request
      click_link('Requests')
      expect(page).to have_content('Hidden Gem of Beverly Hills')
      expect(page).to have_content('2019-07-17')
    end
  end

  context 'all requests received are being displayed' do
    scenario 'user is able to view all requests received in /requests route' do
      make_request
      click_button('Log Out')
      login_as_host
      click_link('Requests')
      expect(page).to have_content('Requests Received')
      expect(page).to have_content('Hidden Gem of Beverly Hills')
      expect(page).to have_content('2019-07-17')
    end
  end
end
