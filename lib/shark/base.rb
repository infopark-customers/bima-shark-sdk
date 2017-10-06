module Shark
  class Base < JsonApiClient::Resource
    self.json_key_format = :underscored_key

    self.connection_class = Shark::Client::Connection
    self.connection_options = {
      headers: {
        'Content-Type' => 'application/vnd.api+json',
        'Accept' => 'application/vnd.api+json'
      }
    }

    class << self
      def add_datetime_accessors(*method_names)
        method_names.each do |name|
          # get
          define_method name do
            value = super()
            DateTime.parse(value)  if value
          end

          # set
          define_method "#{name}=" do |value|
            if value.respond_to?(:iso8601)
              super(value.iso8601(0))
            else
              super(value)
            end
          end
        end
      end
    end
  end
end
