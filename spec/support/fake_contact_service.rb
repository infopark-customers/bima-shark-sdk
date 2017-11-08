module FakeContactService
  def self.setup
    Request.setup
  end

  def self.reset
    ObjectCache.clear
  end
end
