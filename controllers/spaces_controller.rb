require_relative '../lib/spaces'
require_relative '../lib/user'

class MakersBnB < Sinatra::Base
  get '/listings' do
    @user = User.find(id: session[:user_id])

    if @user
      @date = session[:check_in_date]
      
      @spaces = Space.retrieve_available(
        user_id: session[:user_id], 
        date: session[:check_in_date]
      )

      erb :listings
    else
      flash[:notice] = 'Please log in to view listings'
      redirect('/sessions/new')
    end
  end

  get '/add_space' do
    @user = User.find(id: session[:user_id])

    if @user
      erb(:add_new_property)
    else
      flash[:notice] = 'Please log in to add a space'
      redirect('/sessions/new')
    end
  end

  post '/listings/new' do
    Space.create(
      name: params[:property_name],
      description: params[:property_description],
      location: params[:property_location],
      price: params[:property_price],
      user_id: session[:user_id]
    )

    redirect('/listings_all')
  end

  post '/listings/results' do
    session[:check_in_date] = params[:check_in_date]
    redirect '/listings'
  end

  get '/listings_all' do
    @spaces = Space.all

    erb :listings_all
  end
end
