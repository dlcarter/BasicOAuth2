# BasicOAuth2
A simple sinatra app to solve a programming challenge to implement a slice of the OAuth2 spec

Only requirements are a working Ruby installation

## How to get started

1. `bundle install`
2. `ruby app/application.rb`

## Running the tests

`ruby test/auther.rb`

## Hitting the angular application

Simply fire up your browser, and point it at:
[http://localhost:4567/app/index.html](http://localhost:4567/app/index.html)

To test the authentication, follow these steps:

#### 1. Create a client
Click the 'Add client' button and fill in the details. You should see clients appear on the list as you add them.

#### 2. Create a user
Navigate to the client you created above by clicking its name in the clients list. From there, you will see a page with a list of users for that client. It will be empty the first time you navigate there. Create a user by clicking 'Add User' at the bottom of the list.

#### 3. Login your new user
Right click 'Login' at the top right of the screen. Fill in the credentials you created in step 2, including the client.

#### 4. Success!
Navigate, refresh, see that you're authenticated. You can logout and destroy your session by clicking 'Log out' at the top right of the screen.


## (Old) Providing sample data and testing the API by hand

Easiest way is to use curl.

#### Step 1: Create a client:
`curl -d "name=CLIENTNAME" http://localhost:4567/clients`

(Take note of the client key we got back)

#### Step 2: Create a user:
`curl -d "name=FRIENDLYNAME&username=USERNAME&password=PASSWORD&client_key=CLIENT_KEY" http://localhost:4567/users`

#### Step 3: Authenticate the user:
`curl -d "username=USERNAME&password=PASSWORD&grant_type=password" http://localhost:4567/token`

(Take note of the refresh token we get back)

#### Step 4: Refresh authentication with the refresh token
`curl -d "grant_type=refresh_token&refresh_token=REFRESH_TOKEN" http://localhost:4567/token`
