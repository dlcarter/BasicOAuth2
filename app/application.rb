require 'sinatra' 
require 'sinatra/activerecord'
require './config/environments'
Dir["./app/models/*"].each {|file| require file }
set :public_folder, 'public'
set :database_file, "../config/database.yml"

after do
  ActiveRecord::Base.clear_active_connections!
end   

helpers do
  def paramify_json
    # This will allow us to accept both JSON body and query params
    begin
      json_params = JSON.parse(request.body.read)
    rescue
      json_params = {}
    end
    params.merge!(json_params).symbolize_keys!
  end
end

# TODO: Secure, salt, hash etc the password
# For creating users in the system
# POST users#create
# Params:
#   name: (optional) Friendly name of the user
#   username: self explanatory
#   password: self explanatory
post '/clients/:client_id/users' do
  paramify_json
  begin
    @client = Client.find(params[:client_id])
    @user = User.new(name: params[:name], username: params[:username], password: params[:password], client: @client)
    
    if @user.save
      return 201
    else
      return [422, { errors: @user.errors }.to_json]
    end
  rescue ActiveRecord::RecordNotFound
    return [400, { errors: "Could not find client" }.to_json]
  rescue
    return [400, { errors: "An unknown error has occured" }.to_json]
  end
end

# For registering a new client in the system
# POST clients#create
post '/clients' do
  paramify_json
  sanitized_params = params.slice(:name)
  @client = Client.new(sanitized_params)
  if @client.save
    return [201, @client.to_json]
  else
    return [422, { errors: @client.errors }.to_json]
  end
end

# GET clients#index
get '/clients' do
  return Client.all.to_json
end

get '/clients/:id' do
  return Client.find(params[:id]).to_json
end

get '/clients/:id/users' do
  return Client.find(params[:id]).users.to_json
end

# POST token
# Params:
#   grant_type: currently supports only 'password' or 'refresh_token'
#   username: (password grant_type only) username to authenticate
#   password: (password grant_type only) password to authenticate
#   refresh_token: (refresh_token grant_type only) auth token to refresh
post '/token' do
  paramify_json
  begin
    case params[:grant_type].downcase
    when 'password'
      u = User.find_by!(username: params[:username], password: params[:password])
      s = Session.first_or_create(user_id: u.id)
    when 'refresh_token'
      s = Session.find_by!(refresh_token: params[:refresh_token])
    else
      return [400, { error: "invalid_grant" }.to_json]
    end
    s.refresh!
    return [200, {
      access_token: s.token,
      refresh_token: s.refresh_token,
      token_type: "example",
      expires_in: (s.expires_at - Time.now).to_i
    }.to_json]
  # When an auth record is not found in this context, they are not authorized
  rescue ActiveRecord::RecordNotFound => ex
    return [400, { error: "invalid_client" }.to_json]
  end
end
