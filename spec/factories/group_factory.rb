# TODO remove factories
FactoryGirl.define do
  factory :shark_contact_service_group, class: Shark::ContactService::Group do
    skip_create

    sequence(:id) { |n| n.to_i }
    sequence(:title) { |n| "Group #{id}" }
    members_can_admin true

    # contacts
    transient do
      contacts []
    end

    after(:create) do |group, evalutor|
      relationships = {}
      relationships[:contacts] = evalutor.contacts.map do |contact|
        { type: "contacts", id: contact.id }
      end

      data = {
        id: group.id,
        type: "groups",
        attributes: { title: group.title, members_can_admin: group.members_can_admin },
        relationships: relationships
      }

      FakeContactService::ObjectCache.instance.add(data)
    end
  end
end
