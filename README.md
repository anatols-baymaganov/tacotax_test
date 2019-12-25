# Tacotax - Backend technical test
## Summary
1. Objective
2. Technologies used
3. Specificities
4. Next steps

## Objective :
The main goal is to create a service that would allow us to upload a questionnaire and retrieve its data in JSON format.
These data are used to build the following [service](https://www.tacotax.fr/defiscalisation/slider)
Form data would need to be validated before being saved

Description :

* Simple page allowing to upload a yaml file. POST `localhost:3000/questionnaires`  
  (upload file is yaml because it is less verbose than json)
* Validation on questionnaire format
* Endpoint to retrieve questionnaire data from its reference. GET `localhost:3000/questionnaires/:reference`
* Write at least one test on implemented features
* Questionnaire example is the [following](https://github.com/tacotax/test-technique-backend/blob/master/questionnaire.yml)

## Technologies :
Ruby on Rails, database choice is free
Rspec for unit tests

You can make a repo are send us the file as a zip package

## Specificities :
### Upload
* Upload page, GET `localhost:3000/questionnaires/new` allow to choose which file to upload
* POST `localhost:3000/questionnaires` with chosen file
* If questionnaire is valid, redirect to uplaod page with message `L'upload du questionnaire a réussi`
* If questionnaire is not valid redirect to uplad page but display reference of elements that had issues

### Element types
* questionnaire :  
  root element, its reference will be used in order to get JSON via GET `localhost:3000/questionnaires/:reference`.  
  Service validate presence of a reference and at least a content
* slide :  
  represents one "page" of questionnaire  
  validates, reference, label and one content presence at least
* text_input :  
  validates reference and label presence
* number_input :  
  validates reference and label presence
* boolean :  
  validates reference and label presence
* single_choice :  
  validates reference and label presence, and at least on response element
  response element validate value and label presence
* multiple_choice :  
  validates reference and label presence, and at least on response element
  response element validate value and label presence

### Questionnaire Validation
* form must be uploaded as YAML
* every questionnaire element should have a type
* only previously describe types are allowed
* Every element validate what is described previously

### Next Step
We might discuss :
* Data storage choices
* implementation of a versionning feature

### Development setup:

    cp config/database.yml.example config/database.yml
    docker-compose up
    docker-compose exec web bundle exec rails db:create
    docker-compose exec web bundle exec rails db:migrate
