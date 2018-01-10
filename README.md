# `bima-shark-sdk`


## Installation

Include **bima-shark-sdk** in your Gemfile and put the gem in the vendor/cache directory of your Rails application.

```ruby
  gem "bima-shark-sdk"
```

## Configuration

```ruby
  Shark.configure do |config|
    config.contact_service.site = __CONTACTSERVICE_URL__
    config.contact_service.headers = {}

    config.survey_service.site = __MILACRM_URL__
    config.survey_service.headers = {}

    config.form_service.site = __FORMSERVICE_URL__
    config.form_service.headers = {}
  end
```

## Documentation

Please find the documentation in the [wiki](https://github.com/infopark-customers/bima-shark-sdk/wiki/Home)

### Survey Service

```ruby
Shark.with_service_token(token.jwt) do
  # Find a survey
  survey = Shark::SurveyService::Survey.find("d45ff6b0-55d5-0135-451e-784f436a1198")

  # Add a participant
  survey.add_participant({ participant_type: "test", external_id: "foobar@example.com", additional_data: { song: "Boom Boom Boom!" }})

  # Find a participant
  participant = Shark::SurveyService::Participant.find("d45ff6b0-55d5-0135-451e-784f436a1198")
  participant.participated?   # => true or false

  # Set participant#state to "participated" and saves it
  participant.participate
end
```

