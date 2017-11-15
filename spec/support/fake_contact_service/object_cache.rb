module FakeContactService
  class ObjectCache
    include Singleton
    attr_accessor :objects

    def initialize
      @objects = []
    end

    def self.clear
      instance.objects = []
    end

    def add(object)
      object = object_with_default_attributes(object)
      objects.push(object)
    end


    private

    # TODO See https://github.com/infopark-customers/bima-milacrm/blob/develop/spec/support/fake_crm/contact_cache.rb
    def object_with_default_attributes(object)
      object = object.dup

      if object["type"] == "contacts"
        object["attributes"]["account_id"] ||= nil
      end

      object
    end
  end
end
