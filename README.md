# `bima-shark-sdk`


## Installation

Include **bima-shark-sdk** in your Gemfile and put the gem in the vendor/cache directory of your Rails application.

```ruby
  gem 'bima-shark-sdk'
```

## Configuration

```ruby
  Shark.configure do |config|
    config.survey_service.site = URI.join(__MILACRM_URL, '/api/v1/projects/').to_s
    config.survey_service.headers = {}

    config.form_service.site = URI.join(__FORM_SERVICE,, '/api/v1/').to_s
    config.form_service.headers = {}
  end
```

### Usage

TODO
