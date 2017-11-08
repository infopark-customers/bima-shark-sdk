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

    def json_body(id)
      object = objects.detect { |o| o.attributes["id"].to_s == id.to_s }

      p "****jbody called"
      p object

       x = {
        data: {
          id: object["id"],
          type: "groups",
          attributes: {
            title: object["title"],
            members_can_admin: object["members_can_admin"]
          }
        }
      }

      p "*** x:"
      p x

      x
    end
  end
end
