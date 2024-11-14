# bima-shark-sdk

[![Build Status](https://travis-ci.com/infopark-customers/bima-shark-sdk.svg?token=E8GNUMCMv7q5uwHSaqs7&branch=develop)](https://travis-ci.com/infopark-customers/bima-shark-sdk)

## Installation

Include **bima-shark-sdk** in your Gemfile and put the gem in the vendor/cache directory of your Rails application.

```ruby
  gem "bima-shark-sdk"
```

## Configuration

```ruby
  Shark.configure do |config|
    config.asset_service.site = __ASSET_SERVICE_URL__

    config.contact_service.site = __CONTACT_SERVICE_URL__

    config.consent_service.site = __CONSENT_SERVICE_URL__

    config.double_opt_in_service.site = __DOUBLE_OPT_IN_SERVICE_URL__

    config.form_service.site = __FORM_SERVICE_URL__

    config.subscription_service.site = __SUBSCRIPTION_SERVICE_URL__

    config.survey_service.site = __MILACRM_URL__
  end
```

If you want to send emails in your application also add:

```ruby
Shark::MailingService.use_shark_mailer do |mailer|
  mailer.context_helpers = [
    ActiveSupport::NumberHelper
  ]
  mailer.default_layout = 'system_2019'
  mailer.default_template_root = File.expand_path('../../app/views', __dir__)
end
```

To sign your requests with custom tokens, for instance with JWT:
```ruby
  def deliver
    access_id = 'access_id'
    secret_key = 'secret_key'

    signature = JWT.encode({ exp: Time.now.to_i + (1 * 60) }, secret_key, 'HS256')

    Shark.with_auth_token("JWT #{access_id}:#{signature}") do
      super
    end
  end

```

## Testing

```
bundle exec rake spec
```

## Documentation

Please look for the documentation in the [wiki](https://github.com/infopark-customers/bima-shark-sdk/wiki/Home).
