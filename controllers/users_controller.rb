class MakersBnB < Sinatra::Base
  get '/users/new' do
    erb(:index)
  end

  post '/users' do
    found_user = User.find_by_email(email: params['email'])

    if found_user
      flash[:notice] = 'Email already registered'
      redirect('users/new')
    else
      user = User.create(
        name: params['name'],
        email: params['email'],
        password: params['password']
      )

      session[:user_id] = user.id
      redirect('/dashboard')
    end
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
    redirect('/sessions/new')
  end
end
