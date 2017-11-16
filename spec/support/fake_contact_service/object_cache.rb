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
      objects.push(object)
    end

    def filter_objects(type, params)
      equals_attributes = params["filter"] && params["filter"]["filter"] && params["filter"]["filter"]["equals"]
      filtered_objects = []

      if equals_attributes.present?
        filtered_objects = objects.select do |object|
          object["type"] == type && equals_attributes.all? do |attr, value|
            object["attributes"][attr] == value
          end

        end
      end

      filtered_objects
    end
  end
end
