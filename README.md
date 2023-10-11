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