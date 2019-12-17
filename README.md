# tacotax_test

#### Development setup:

    cp config/database.yml.example config/database.yml
    docker-compose up
    docker-compose exec web bundle exec rails db:create
    docker-compose exec web bundle exec rails db:migrate
