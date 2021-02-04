# frozen_string_literal: true

module Shark
  module NormalizedEmail
    extend ActiveSupport::Concern

    class_methods do
      def normalize_email(email)
        email.to_s.downcase.strip
      end
    end
  end
end
