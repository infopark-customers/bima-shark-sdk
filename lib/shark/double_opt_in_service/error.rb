module Shark
  module DoubleOptInService
    class ExceededNumberOfVerificationRequestsError < Error; end
    class RequestedUnverifiedExecutionError < Error; end
    class VerificationExpiredError < Error; end
  end
end
