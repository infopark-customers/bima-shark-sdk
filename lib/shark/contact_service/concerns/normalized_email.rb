module Shark
  module ContactService
    module Concerns
      module NormalizedEmail
        def normalize_email(email)
          email.to_s.downcase.strip
        end
      end
    end
  end
end
