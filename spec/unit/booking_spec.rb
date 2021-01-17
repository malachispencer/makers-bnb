describe Booking do
  let(:host) { 
    User.create(
      name: 'Malachi',
      email: 'm.spencer@makers.com',
      password: '2020'
    )
  }

  let(:guest) { 
    User.create(
      name: 'Constantine',
      email: 'constantine@makers.com',
      password: '2020'
    )
  }

  let(:guest_two) {
    User.create(
      name: 'Alex',
      email: 'alm@makers.com',
      password: '2020'
    )
  }

  let(:space) {
    Space.create(
      name: 'Ealing Flat',
      description: 'Studio apartment',
      location: 'Ealing, London, UK',
      price: 150,
      user_id: host.id
    )
  }

  let(:today) { Date.today.to_s }

  describe '.create' do
    it 'adds a booking to the database and returns it' do
      booking = Booking.create(
        check_in: today,
        booked: false,
        space_id: space.id,
        user_id: guest.id
      )

      expect(booking.check_in).to eq(today)
      expect(booking.booked).to eq('f')
      expect(booking.space_id).to eq(space.id)
      expect(booking.user_id).to eq(guest.id)
    end
  end

  describe '.all' do
    it 'gets all bookings from the bookings table' do
      booking_one = Booking.create(
        check_in: today,
        booked: false,
        space_id: space.id,
        user_id: guest.id
      )

      booking_two = Booking.create(
        check_in: today,
        booked: false,
        space_id: space.id,
        user_id: guest_two.id
      )

      results = Booking.all


      expect(results.length).to eq(2)
    end
  end

  describe '.retrieve_requests_made' do
    it 'retrieves all requests made by a specific user' do
      booking = Booking.create(
        check_in: today,
        booked: false,
        space_id: space.id,
        user_id: guest.id
      )

      requests_made = Booking.retrieve_requests_made(user_id: guest.id).first

      expect(requests_made['host_name']).to eq(host.name)
      expect(requests_made['check_in']).to eq(today)
      expect(requests_made['name']).to eq(space.name)
    end
  end

  describe '.retrieve_requests_received' do
    it 'retrieves all requests received' do
      Booking.create(
        check_in: Date.today.to_s, 
        booked: false,
        space_id: space.id, 
        user_id: guest.id
      )

      result = Booking.retrieve_requests_received(user_id: host.id).first

      expect(result['guest_name']).to eq(guest.name)
      expect(result['name']).to eq(space.name)
    end
  end

  describe '.confirm' do
    it 'updates booked to TRUE' do
      booking = Booking.create(
        check_in: Date.today.to_s, 
        booked: false,
        space_id: space.id, 
        user_id: guest.id
      )

      confirmation = Booking.confirm(booking_id: booking.id)

      expect(confirmation.first['booked']).to eq('t')
    end
  end

  describe '.deny' do
    it 'removes the booking from the bookings table' do
      booking = Booking.create(
        check_in: Date.today.to_s, 
        booked: false,
        space_id: space.id, 
        user_id: guest.id
      )

      Booking.deny(booking_id: booking.id)

      db_response = DatabaseConnection.query(
        "SELECT * 
        FROM bookings 
        WHERE id = '#{booking.id}';"
      ).first

      expect(db_response).to be_nil
    end
  end

  describe '.retrieve_confirmed_bookings' do
    it 'retrieves all confirmed bookings as guest' do
      Booking.create(
        check_in: Date.today.to_s, 
        booked: true,
        space_id: space.id, 
        user_id: guest.id
      )

      results = Booking.retrieve_confirmed_bookings(
        host_or_guest: 'guest', 
        user_id: guest.id
      ).first

      expect(results['host_name']).to eq(host.name)
      expect(results['host_email']).to eq(host.email)
    end

    it 'retrieves all confirmed bookings as host' do
      Booking.create(
        check_in: Date.today.to_s, 
        booked: true,
        space_id: space.id, 
        user_id: guest.id
      )

      result = Booking.retrieve_confirmed_bookings(
        host_or_guest: 'host', 
        user_id: host.id
      ).first

      expect(result['guest_name']).to eq(guest.name)
      expect(result['guest_email']).to eq(guest.email)
    end
  end
end