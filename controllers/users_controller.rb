# frozen_string_literal: true

class MakersBnB < Sinatra::Base
  get '/users/new' do
    erb(:sign_up)
  end

  post '/users' do
    user = User.create(
      name: params['name'],
      email: params['email'],
      password: params['password']
    )

    session[:user_id] = user.id
    redirect('/dashboard')
  end

  get '/sessions/new' do
    erb(:login)
  end

  post '/sessions' do
    user = User.authenticate(
      email: params['email'],
      password: params['password']
    )

    if user
      session[:user_id] = user.id
      redirect('/dashboard')
    else
      flash[:notice] = 'Login details incorrect - please try again'
      redirect('/sessions/new')
    end
  end

  post '/sessions/destroy' do
    session.clear
    flash[:notice] = 'Succesfully Logged Out'
    redirect('/')
  end
end
