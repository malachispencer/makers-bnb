# frozen_string_literal: true

class MakersBnB < Sinatra::Base
  get '/request_confirmation/:id' do
    Booking.create(
      check_in: session[:check_in_date],
      booked: false,
      space_id: params[:id],
      user_id: session[:user_id]
    )

    erb(:request_confirmation)
  end

  get '/requests' do
    @user = User.find(id: session[:user_id])

    if @user
      @requests_made = Booking.retrieve_requests_made(user_id: session[:user_id])
      @requests_received = Booking.retrieve_requests_received(user_id: session[:user_id])
      erb :requests
    else
      flash[:notice] = 'Please login to view requests'
      redirect '/sessions/new'
    end
  end

  patch '/requests/:id' do
    Booking.confirm(booking_id: params[:id])
    redirect '/requests'
  end

  delete '/requests/:id' do
    Booking.deny(booking_id: params[:id])
    redirect '/requests'
  end

  get '/confirmed_bookings' do
    @user = User.find(id: session[:user_id])

    if @user
      @bookings_guest = Booking.retrieve_confirmed_bookings(host_or_guest: 'guest', user_id: session[:user_id])
      @bookings_host = Booking.retrieve_confirmed_bookings(host_or_guest: 'host', user_id: session[:user_id])
      erb :confirmed_bookings
    else
      flash[:notice] = 'Please login to view bookings'
      redirect '/sessions/new'
    end
  end
end
