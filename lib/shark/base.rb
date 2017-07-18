module Shark
  class Base < JsonApiClient::Resource
    self.json_key_format = :dasherized_key

    self.connection_class = Shark::Client::Connection
    self.connection_options = {
      headers: {
        'Content-Type' => 'application/vnd.api+json',
        'Accept' => 'application/vnd.api+json'
      }
    }
  end
end
