FactoryGirl.define do
  factory :shark_contact_service_group, class: Shark::ContactService::Group do
    skip_create

    sequence(:id) { |n| n.to_i }
    sequence(:title) { |n| "Group #{id}" }
    members_can_admin true

    # contacts 

    after(:create) do |group|
      ObjectCache.instance.add(group)
    end
  end
end
