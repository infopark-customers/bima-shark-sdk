# `bima-shark-sdk`


## Installation

Include **bima-shark-sdk** in your Gemfile and put the gem in the vendor/cache directory of your Rails application.

```ruby
  gem "bima-shark-sdk"
```

## Configuration

```ruby
  Shark.configure do |config|
    config.asset_service.site = __ASSETSERVICE_URL__

    config.contact_service.site = __CONTACTSERVICE_URL__

    config.survey_service.site = __MILACRM_URL__

    config.form_service.site = __FORMSERVICE_URL__

    config.subscription_service.site = __SUBSCRIPTIONSERVICE_URL__
  end
```

## Documentation

Please look for the documentation in the [wiki](https://github.com/infopark-customers/bima-shark-sdk/wiki/Home).
