# TODO remove factories
FactoryGirl.define do
  factory :shark_contact_service_contact, class: Shark::ContactService::Contact do
    skip_create

    sequence(:id) { |n| n }

    after(:create) do |contact|
      data = {
        id: contact.id,
        type: "contacts",
        attributes: {}
      }

      FakeContactService::ObjectCache.instance.add(data)
    end
  end
end
