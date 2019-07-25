## Changelog

### 0.13.1
- [fix] `attachments` attribute for `Mail` objects needs to be a hash 

### 0.13.0
- make all `Mail` attributes known to `BaseMailer`

### 0.12.0
- add `MailingService.use_shark_mailer`

### 0.11.0
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
