describe Booking do

  let(:user) { create_ollie }
  let(:user_2) { create_anna }
  let(:listing) { create_listing(user_id: user.id) }

  # let(:results) { persisted_data(id: new_user.id, table: 'booking') }
  subject(:booking) { described_class.create(visitor_id: user.id, listing_id: listing.id) }
  describe '.create' do
    it 'returns a booking' do
      expect(booking.visitor_id).to eq user.id
      expect(booking.listing_id).to eq listing.id
      expect(booking.status).to eq 'pending'
    end
  end

  describe '.all' do
    it 'lists all bookings' do
      booking
      new_booking = Booking.create(visitor_id: user.id, listing_id: listing.id)

      bookings = Booking.all

      expect(bookings.length).to eq 2
      expect(bookings).to all(be_an_instance_of(Booking))
      expect(bookings.first.id).to eq new_booking.id
      expect(bookings.first.visitor_id).to eq new_booking.visitor_id
      expect(bookings.first.listing_id).to eq new_booking.listing_id
    end
  end

  describe '.where(field:, id:)' do
    it 'displays all bookings field current user' do
      listing_2 = Listing.create(name: 'My other place', description: '2 bed', price_per_night: 200, user_id: user.id)

      booking
      booking_2 = Booking.create(visitor_id: user.id, listing_id: listing_2.id)
      booking_3 = Booking.create(visitor_id: user_2.id, listing_id: listing.id)

      bookings = Booking.where(field: "visitor", id: user.id)

      expect(bookings.length).to eq 2
      expect(bookings).not_to include booking_3
      expect(bookings).to all(be_an_instance_of(Booking))
      expect(bookings.first.visitor_id).to eq user.id
      expect(bookings.last.visitor_id).to eq user.id
    end

    it 'displays all bookings of a listing' do
      listing_2 = Listing.create(name: 'My other place', description: '2 bed', price_per_night: 200, user_id: user.id)

      booking
      booking_2 = Booking.create(visitor_id: user.id, listing_id: listing_2.id)
      booking_3 = Booking.create(visitor_id: user_2.id, listing_id: listing.id)

      bookings = Booking.where(field: "listing", id: listing.id)

      expect(bookings.length).to eq 2
      expect(bookings).not_to include booking_2
      expect(bookings).to all(be_an_instance_of(Booking))
      expect(bookings.first.visitor_id).to eq user.id
      expect(bookings.last.visitor_id).to eq user_2.id
    end
  end

  describe '.update' do
    it 'approves a pending booking' do
      owner_listing = listing
      customer = create_anna

      booking = Booking.create(visitor_id: customer.id, listing_id: owner_listing.id)
      booking_update = Booking.update(id: booking.id, status: 'approved')

      expect(booking_update.status).to eq 'approved'
      expect(booking_update.status).not_to eq 'rejected'
      expect(booking_update.status).not_to eq 'pending'
    end

    it 'rejects a pending booking' do
      owner_listing = listing
      customer = create_anna

      booking = Booking.create(visitor_id: customer.id, listing_id: owner_listing.id)
      booking_update = Booking.update(id: booking.id, status: 'rejected')

      expect(booking_update.status).not_to eq 'approved'
      expect(booking_update.status).to eq 'rejected'
      expect(booking_update.status).not_to eq 'pending'
    end
  end
end
