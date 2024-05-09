# Mtg Roto App

This web app uses rails for the framework, Postgres for the database, Bootstrap CSS for styling, Stimulus for client side controllers, and esbuild to bundle it.

## Prerequisites

This web application is contained within docker images, so most of the prerequisites are taken care of by the dockerfile. With that said, things that would be good to have installed are:
- Ruby 3.3.0 https://www.ruby-lang.org/en/documentation/installation/
- Docker https://docs.docker.com/get-docker/

## Docker

Our web application and database can be run within docker containers that compartmentalize the application. This allows us to spin up this application on multiple different machines with the same result every time.

To run the application with docker we use a docker-compose file which allows us to define and manage our multi-container application (web and db).
- To build the images, run `docker-compose build`. This will compile the image using what we have defined in our docker-compose.yml file. For our web image the Dockerfile is used to construct our environment.
- To run the application (both db and web), run `docker-compose up`. This will host our site locally at port 3000 for the web (http://localhost:3000) and port 5432 for the db. Note that these ports cannot be in use to run the app.

## Development

### Updating gems locally
- Run `bundle install` which will install all gems in your Gemfile (this includes rails)

### Updating JS

Javascript controllers are located in app/javascript/controllers/

To ensure that the most updated JS is being used, you must precompile your assets. Also, if you have added a new JS controller, it needs to be included in the index.js file.
- To automatically update the index.js file, run `rails stimulus:manifest:update`.
- To precompile JS assets after updating, run `rails assets:clean && rails assets:precompile`

### CSS

We are mostly just using BootstrapCSS to define the css classes we use throughout the application. Bootstrap documentation can be found [here](https://getbootstrap.com/docs/5.0/getting-started/introduction/).
To define custom css, you need to add a .css.scss file under app/assets/stylesheets (or update an existing file). If you are adding a new file, to get it to load into the app you must:
- Add an entry on the manifest.js file (i.e. //= link cube_card.css)
- Add a stylesheet link tag in application.html.erb (i.e. <%= stylesheet_link_tag "cube_card", "data-turbo-track": "reload" %>)

### Updating the database schema

Rails uses ActiveRecord to manage Postgres. If you want to update a table or create a new table, you'll need to create a new database migration file. Those are located at db/migrate/.
- To automatically generate a migration file, run `rails g migration NameOfMigrationHere`. The naming convention should generally correlate with the name of the table and/or column being manipulated (i.e. CreateDrafts or AddActiveRoundToDraft).
- To run migrations, you'll want to do it inside the container, so run `docker-compose exec web rails db:migrate`. For your specs to see the new changes, you'll also need to run it for the test environment `docker-compose exec web rails db:migrate RAILS_ENV=test`.

### Running specs

We use rspec for unit testing. To run our unit tests, run `rspec spec`. To run a specific spec file run `rspec path/to/file`. All our specs are in the spec directory.

## Debugging

### Using debugger

If you want to set a breakpoint in ruby, simply add a line in the code where you want to add a breakpoint with `debugger`. Before you hit the breakpoint, you'll need to attach into your web container:
1. `docker ps` to see all running containers. 
2. Copy the container id of the web container. 
3. Run `docker attach [container_id]`. Now stdout will show up in that terminal session.

Once you are attached to the container, when you hit the breakpoint the application will stop and you can navigate inside the code in that terminal.
- Type `next` to move to the next line
- Type `step` to move into the current line
- Type `continue` to go to the next breakpoint

### Using the rails console

Sometimes you'll just want to execute some ruby code inside the context of the application. To do that you need to enter the rails console. Run `docker-compose exec web rails c`.

## Deployment
TBD - look into Kamal and DigitalOcean droplets
