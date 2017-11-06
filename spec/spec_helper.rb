require "bundler/setup"
require "shark"
require "webmock/rspec"

# TODO
# require "spec/support/object_cache"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  # TODO
  # config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    contact_service_api = "#{Shark.configuration.contact_service.site}"

    ObjectCache.instance.objects = []

    stub_request(:get, %r|^#{contact_service_api}groups/.*|).to_return do |request|
      id = request.uri.path.split('/')[3]
      object = ObjectCache.instance.objects.detect { |o| o.attributes["id"].to_s == id.to_s && o.attributes["type"] == "groups" }

      {
        headers: { content_type: "application/vnd.api+json" },
        body: {
          data: {
            id: id,
            type: "groups",
            attributes: {
              title: object["title"],
              members_can_admin: object["members_can_admin"]
            }
          }
        }.to_json
      }
    end
  end
end
