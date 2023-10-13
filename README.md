# README

This README contains steps to get the application up and running along with the details on features covered as part of the application.

Things you may want to cover:

## Prerequisites to start app in local machine
- Ruby version 3.2.2

_Note: If only a different version is available then you can choose to use rbenv to install and manage your ruby versions. Click [link1](https://andyatkinson.com/TaskManager/2019/08/01/using-rbenv-multiple-ruby-versions) and [link2](https://stackoverflow.com/a/39238995) for instructions_

- Bundler version 2.4.14

_Note: This is the tested bundler version. If you face any bundler issues you can use this [link](https://bundler.io/TaskManager/2019/05/14/solutions-for-cant-find-gem-bundler-with-executable-bundle.html) to fix it_

- plsql version 12.15

- docker version
_Note: Docker is used only if you want to deploy the service to a docker container_

### Database creation and schema setup for the application
Run the following commands to create and setup the database
```
rake db:setup
rake db:migrate
```

### How to run the test suite
Note that before running the test for this application run the following command to setup the database environment `rake db:test:prepare`
rspec testing suite is used to test application. The following commands are used to run all tests `rspec`

to run specific tests `rspec spec/<filename>.rb:<context/test line number>`

### Configuration
This application is accessible as both a web app and via api

### Deployment instructions

* System dependencies

* Services (job queues, cache servers, search engines, etc.)

### API requests

#### SIGN UP
```
curl -X POST http://localhost:3000/api/users/sign_up -i -H "Accept: application/json" \
   -H 'Content-Type: application/json' \
   -d '{"user" : {"email":"user31@gmail.com","password":"123456", "address": "Ireland, Dublin"}}'
```
_Note:_
- _Post sign up, login again via api to get the token from authorisation header_
- _Send only "<city>, <country>" in address for the coordinated to be assigned without erroring out_

#### SIGN IN
```
curl -X POST http://localhost:3000/api/users/sign_in -i -H "Accept: application/json" \
   -H 'Content-Type: application/json' \
   -d '{"user" : {"email":"user41@gmail.com","password":"111111"}}'
```
_Note:_
- _The api token is set to expire after 1hr. The same is configured for useres logged in via web_
- _Use the token from authorisation header to perform other actions_

#### SIGN OUT
```
curl -X DELETE http://localhost:3000/api/users/sign_out -H 'Content-Type: application/json' \
  -H "Authorization: Bearer <TOKEN>"
```
_Note: Once signed out the api token becomes invalid for login_


#### CREATE TASK

```
curl -X POST http://localhost:3000/tasks -i -H "Accept: application/json" \
   -H 'Content-Type: application/json' \
   -d '{"task" : {"title":"task2","description":"task2 body"}}' \
   -H "Authorization:  Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzMCIsInNjcCI6InVzZXIiLCJhdWQiOm51bGwsImlhdCI6MTY5MjYyNjE0NywiZXhwIjoxNjkyNjI5NzQ3LCJqdGkiOiJkMjY2OThlYi04MzY4LTQ5NzQtOWFiZS0yZTE3YjZlMTg1OTQifQ.fbpotssTvl7_GPYwOh3l1q24LwBDE68bJgzGNxPhIzc"
```


#### GET ALL TASKS
```
curl http://localhost:3000/tasks -H "Accept: application/json" \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer <TOKEN>"
```

#### GET TASKS BY ID
```
curl http://localhost:3000/tasks/<id> -H "Accept: application/json" \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer <TOKEN>"
```

### To do
- add signout in web ui
- update of tasks
- delete of tasks
- convert date to epoc seconds and save and view versa to show
- Check cron job once api is active
- Error handling when userLocationinfo doesn't get added post user save properly
- write more tests

### Ruby coding standards followed
- Use %i or %I for an array of symbols
- Single quoted strings when there in no string interpolation involved
- Use snakecase for method and variable names
- Use inbuilt ruby method instead of repeating the checks manually
- Use 2 space indentation instead of 4
- space missing around symbols like {, }, =, etc
- redundant return statements
- Removing trailing whitespaces
- Condition size for method too high
- Refactor to the new Ruby 1.9 hash syntax
- Value omission in hash literals

### Security ensured
- Sensitive information is not stored in sessions
  - Only user id is part of session
  - Todo: ssl integration to not allow session hijacking in general
- User sessions are not stored in cookies
  - Cookie hash stored in client end could be used for malicious activity if rails app secret key (secret_key_base) is not secured enough
- Set session expiry in devise settings to avoid session fixation
  - session fixation is when hackers lure other users to use their active session id for login/registration operations and co-use session ids
- Auth token expiry and session expiry is set in server side. Since it's not part of session hackers can't modify expiry value if it's part of the session
- Sign out user when a CSRF token is not present when hitting from some script and not as json requests
  -  when a CSRF token is not present or is incorrect on a non-GET request then signout user (user id taken from session)
  - Todo : Still if user id is set in the session with same session id, the impersonation as user on GET operations can still happen until expiry or victim user signs out (AKS, CSRF attack). 
- Including only expected parameters to be accepted for the endpoints, even within the body. 
  - Todo: restrict accepting certain query parameters depending on the url
- Redirect all unknown path calls from route to "list tasks path", this doesn't allow hackers to lure customers to page outside of the application
  - Todo: Another way is we can something similar to what linkedin does when we try to hit links outside of the application it notifies the user, "this way user knows that they are under attack" and can mitigate out of the situation
- Checks if tokens generated are getting filtered out form getting printed in the logs using the 'config.filter_parameters' configuration
- Todo: Ensure to include only allowed tags in web application and sanitize even inputs to task endpoints
Reference -> https://guides.rubyonrails.org/security.html#html-javascript-injection-countermeasures
- Todo: Check webmail interface worm like Nduja, Yahoo mail worm, samy worm, etc to understand encoding injection better and how to avoid it
  - Check what all are handled by rails sanitize
- Todo: Understand [this](https://guides.rubyonrails.org/security.html#ajax-injection), have no idea what they are talking about
- Allow only authorization key to be exposed in the header
