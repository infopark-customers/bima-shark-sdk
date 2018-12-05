module Shark
  module DoubleOptInService
    class ExceededNumberOfVerificationRequestsError < Error; end
    class RequestedUnverifiedExecutionError < Error; end
  end
end
