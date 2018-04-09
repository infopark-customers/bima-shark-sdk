## Changelog

#### 0.7.1
- fix: undefined method `responds_to?` in Configuration

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
