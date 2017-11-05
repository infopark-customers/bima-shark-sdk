FactoryGirl.define do
  factory :group, class: Shark::ContactService::Group do
    skip_create

    title { "Foo" }
    members_can_admin true
  end
end
