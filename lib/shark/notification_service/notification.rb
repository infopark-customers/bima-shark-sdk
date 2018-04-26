module Shark
  module NotificationService
    class Notification < Base
      belongs_to :user

      custom_endpoint :read_all, on: :collection, request_method: :patch

    end
  end
end
