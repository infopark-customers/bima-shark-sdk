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
  end
end
