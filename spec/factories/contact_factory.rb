FactoryGirl.define do
  factory :shark_contact_service_contact, class: Shark::ContactService::Contact do
    skip_create

    sequence(:id) { |n| n }

    after(:create) do |contact|
      ObjectCache.instance.add(contact)
    end
  end
end
