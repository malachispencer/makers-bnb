# frozen_string_literal: true

describe Space do
  let(:test_user) { User.create(name: 'Jane Doe', email: 'jane_doe@gmail.com', password: '12345qwerty') }

  describe '.create' do
    it 'is called on the Space class' do
      expect(described_class).to respond_to(:create).with_keywords(:name, :description, :location, :price, :user_id)
    end

    it 'inserts its arguments into the spaces table' do
      result = Space.create(description: 'A luxurious villa in Beverly Hills', name: 'Hidden Gem of Beverly Hills',
                            location: 'Los Angeles, Beverly Hills', price: 300, user_id: test_user.id)
      expect(result).to be_instance_of(described_class)
      expect(result.name).to eq('Hidden Gem of Beverly Hills')
      expect(result.description).to eq('A luxurious villa in Beverly Hills')
      expect(result.location).to eq('Los Angeles, Beverly Hills')
      expect(result.price).to eq(300)
      expect(result.user_id).to eq(test_user.id)
    end
  end

  describe '.retrieve_available' do
    it 'is called on the Spaces class' do
      expect(described_class).to respond_to(:retrieve_available).with(0..1).arguments
    end

    it 'returns all listings from within the spaces table in the database' do
      Space.create(description: 'A luxurious villa in Beverly Hills', name: 'Hidden Gem of Beverly Hills',
                   location: 'Los Angeles, Beverly Hills', price: 300, user_id: test_user.id)
      result = described_class.retrieve_available
      expect(result.first.name).to eq('Hidden Gem of Beverly Hills')
      expect(result.first.description).to eq('A luxurious villa in Beverly Hills')
      expect(result.first.location).to eq('Los Angeles, Beverly Hills')
      expect(result.first.price).to eq(300)
      expect(result.first.user_id).to eq(test_user.id)
    end

    it 'returns all listings that are not booked on a specified date' do
      new_space = Space.create(description: 'A luxurious villa in Beverly Hills', name: 'Hidden Gem of Beverly Hills',
                               location: 'Los Angeles, Beverly Hills', price: 300, user_id: test_user.id)
      random_date = Date.today.to_s
      Booking.create(check_in: random_date, booked: true, space_id: new_space.id, user_id: new_space.user_id)
      result = Space.retrieve_available(random_date)
      expect(result.first).to be_nil
      booking = Booking.retrieve_booking
      expect(booking.first.check_in).to eq(random_date)
      expect(booking.first.booked).to eq('t')
      expect(booking.first.space_id).to eq(new_space.id)
      expect(booking.first.user_id).to eq(new_space.user_id)
    end
  end

  describe '.find_by_id' do
    it 'returns a given space by id' do
      space = Space.create(
        description: 'A luxurious villa in Beverly Hills',
        name: 'Hidden Gem of Beverly Hills',
        location: 'Los Angeles, Beverly Hills',
        price: 300,
        user_id: test_user.id
      )
      found_space = Space.find_by_id(id: space.id)
      expect(found_space.id).to eq(space.id)
    end
  end
end
