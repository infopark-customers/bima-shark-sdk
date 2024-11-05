## Changelog

#### 2.5.0
- Extend `with_service_token` with `with_auth_token` which allows to send custom `Authorization` header, not only `Bearer`
- remove `Shark::Subscription`

#### 2.4.4
* lowest supported Ruby version is 2.7
* add `recipient` to `Shark::DoubleOptIn::Execution`

#### 2.4.3
- allow `Shark::MailingService::Mailer#mail` to use separate layouts
- rename `Shark::MailingService::Mailers::BaseMailer` to `Shark::MailingService::Mailer`

#### 2.4.2
- [fix] don't swallow connection errors

#### 2.4.1
- [fix] Form Service: Added missing `versions` association to `Form`

#### 2.4.0
- added `Shark::Contact#consents` and `Shark::Contact#create_contract`

#### 2.3.1
- [fix] expose `Shark::ContactLog`

#### 2.3.0
- `Shark::MailingService` template can `#render` partials

#### 2.2.0
- added `Shark::ContactLog` resource
- added `Shark::MailingService::Mail#header_image` as parameter

#### 2.1.0
- added `Shark::Contact.find_by_permissions` method

#### 2.0.1
- added `Mail#reply_to` attribute

#### 2.0.0
- added `Shark::Membership.exists?` to quickly check, if a contact is member of a group
- [break] remove `SurveyService` module
- [break] rename `DoubleOptInService` => `DoubleOptIn`
- [break] remove `SubscriptionService` module
- [break] remove `NotificationService` module
- [break] remove `ContactService` module
- [break] remove `ConsentService` module
- [break] remove `AssetService` module

#### 1.0.1
- whitelist `Mail#from` as attribute

#### 1.0.0
- drop support for `json_api_client < 1.10`
- [break] drop Ruby `2.1` support
- use `Rubocop`

#### 0.14.0
- Asset Service Client supports package API

#### 0.13.4
- Add `download` link handling to the `FakeAssetService`.
- [fix] Determining the resource id in `FakeAssetService` fails when the endpoint base path is not `/`.
- [fix] `links` attribute in fake asset service response contains wrong URIs.

#### 0.13.3
- add `X-Forwarded-Proto: https` as default header

#### 0.13.2
- add `SharkSpec.stub_mailing_service`
- cleanup SharkSpec helpers with some meta programming

#### 0.13.1
- [fix] `attachments` attribute for `Mail` objects needs to be a hash

#### 0.13.0
- make all `Mail` attributes known to `BaseMailer`

#### 0.12.0
- add `MailingService.use_shark_mailer`

#### 0.11.0
- extend with MailingService

#### 0.10.3
- [fix] add backwards compatibility to Ruby 2.1
- added Travis CI

#### 0.10.2
- [fix] `ContactService::Group#has_contact?` raised exception without `includes(:contact)`

#### 0.10.1
- Double Opt In Service: added `message_footer_html` attribute to Request

#### 0.10.0
- extend with Double Opt In Service

#### 0.9.0
- extend with AssetService and SubscriptionService

#### 0.8.0
- extend with ConsentService

#### 0.7.5
- extend with NotificationService

#### 0.7.4
- [fix] `Shark::ContactService::Group#has_contact?`

#### 0.7.3
- [fix] doorkeeper spec issue
- use Rails logger when used in Rails apps

#### 0.7.2
- [fix] milacrm spec issue

#### 0.7.1
- [fix] undefined method `responds_to?` in Configuration

#### 0.7.0
- survey rating star support
- survey text field support

#### 0.6.4
- added some annotations
- [break] cleanup client and server errors

#### 0.6.3
- restructured FormService::RSpec (e.g. `SharkSpec.stub_contact_service`)
- form service:
  - removed API v1 resources
  - added FormVersion::form_structure to get a tree model of the pages form


#### 0.6.2
- [break] remove `URI.join()` from `settings.rb` in apps
- contact service:
    - supports activity
- form service:
    - supports API v2

#### 0.6.1
- fixes including of RSpec helper files

#### 0.6.0
- supports Contact Service: accounts, contacts and groups

#### 0.5.1
- added DateTime accessors to SurveyService

#### 0.5.0
- added create participant to SurveyService

#### 0.4.0
- initial version with SurveyService and FormService
