module FakeContactService
  def self.setup
    ObjectCache.clear
    Request.setup
  end

  def self.reset
    ObjectCache.clear
  end
end
