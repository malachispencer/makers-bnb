# frozen_string_literal: true

describe Booking do
  let(:test_user) { User.create(name: 'Jane Doe', email: 'jane_doe@gmail.com', password: '12345qwerty') }
  let(:space) do
    Space.create(description: 'A luxurious villa in Beverly Hills', name: 'Hidden Gem of Beverly Hills',
                 location: 'Los Angeles, Beverly Hills', price: 300, user_id: test_user.id)
  end

  context '.create' do
    it 'is called on the Booking class' do
      expect(described_class).to respond_to(:create).with_keywords(:check_in, :booked, :space_id, :user_id)
    end

    it 'creates a new booking' do
      booking = described_class.create(check_in: Date.today.to_s, booked: false,
                                       space_id: space.id, user_id: test_user.id)
      expect(booking.check_in).to eq(Date.today.to_s)
      expect(booking.booked).to eq('f')
      expect(booking.space_id).to eq(space.id)
      expect(booking.user_id).to eq(test_user.id)
    end
  end

  context '.retrieve_booking' do
    it 'is called on the Booking class' do
      expect(described_class).to respond_to(:retrieve_booking)
    end

    it 'retrieves all bookings from the bookings table' do
      described_class.create(check_in: Date.today.to_s, booked: false,
                             space_id: space.id, user_id: test_user.id)
      result = described_class.retrieve_booking
      expect(result.first.check_in).to eq(Date.today.to_s)
      expect(result.first.booked).to eq('f')
      expect(result.first.space_id).to eq(space.id)
      expect(result.first.user_id).to eq(test_user.id)
    end
  end

  describe '.retrieve_requests_made' do
    it 'is called on the Booking class' do
      expect(described_class).to respond_to(:retrieve_requests_made).with_keywords(:user_id)
    end

    it 'retrieves all requests made by a specific user' do
      described_class.create(check_in: Date.today.to_s, booked: false,
                             space_id: space.id, user_id: test_user.id)
      result = described_class.retrieve_requests_made(user_id: test_user.id)
      expect(result[0]['user_id']).to eq(test_user.id)
      expect(result[0]['name']).to eq('Hidden Gem of Beverly Hills')
      expect(result[0]['check_in']).to eq(Date.today.to_s)
    end
  end

  describe '.retrieve_requests_received' do
    it 'is called on the Booking class' do
      expect(described_class).to respond_to(:retrieve_requests_received).with_keywords(:host_id)
    end

    it 'retrieves all requests received' do
      described_class.create(check_in: Date.today.to_s, booked: false,
                             space_id: space.id, user_id: test_user.id)
      result = described_class.retrieve_requests_received(host_id: space.user_id)
      expect(result[0]['user_id']).to eq(space.user_id)
      expect(result[0]['name']).to eq('Hidden Gem of Beverly Hills')
    end
  end

  describe '.confirm' do
    it 'is called on the Booking class' do
      expect(described_class).to respond_to(:confirm).with_keywords(:booking_id)
    end

    it 'updates the booked column so that it equals TRUE for the given booking_id' do
      result = described_class.create(check_in: Date.today.to_s, booked: false,
                                      space_id: space.id, user_id: test_user.id)
      confirmation = Booking.confirm(booking_id: result.id)
      expect(confirmation.first['booked']).to eq('t')
    end
  end

  describe '.deny' do
    it 'is called on the Booking class' do
      expect(described_class).to respond_to(:deny).with_keywords(:booking_id)
    end

    it 'removes the booking entry from the bookings table' do
      result = described_class.create(check_in: Date.today.to_s, booked: false,
                                      space_id: space.id, user_id: test_user.id)
      Booking.deny(booking_id: result.id)
      verdict = DatabaseConnection.query("SELECT * FROM bookings WHERE id='#{result.id}';")
      expect(verdict.first).to be_nil
    end
  end

  describe '.retrieve_confirmed_bookings' do
    it 'is called on the Booking class' do
      expect(described_class).to respond_to(:retrieve_confirmed_bookings).with_keywords(:host_or_guest, :user_id)
    end

    it 'retrieves all confirmed bookings as guest' do
      described_class.create(check_in: Date.today.to_s, booked: true,
                             space_id: space.id, user_id: test_user.id)
      result = Booking.retrieve_confirmed_bookings(host_or_guest: 'guest', user_id: test_user.id)
      expect(result.first['user_id']).to eq(test_user.id)
    end

    it 'retrieves all confirmed bookings as host' do
      described_class.create(check_in: Date.today.to_s, booked: true,
                             space_id: space.id, user_id: test_user.id)
      result = Booking.retrieve_confirmed_bookings(host_or_guest: 'host', user_id: test_user.id)
      expect(result.first['user_id']).to eq(test_user.id)
    end
  end
end
