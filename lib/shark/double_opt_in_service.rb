require "shark/double_opt_in_service/base"
require "shark/double_opt_in_service/request"
require "shark/double_opt_in_service/execution"

module Shark
  module DoubleOptInService
    class ExceededNumberOfVerificationRequestsError < Error; end
    class RequestedUnverifiedExecutionError < Error; end
    class VerificationExpiredError < Error; end
  end
end
