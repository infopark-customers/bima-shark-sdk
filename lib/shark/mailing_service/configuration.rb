# frozen_string_literal: true

module Shark
  module MailingService
    class Configuration
      attr_accessor :context_helpers, :default_layout, :default_template_root
    end
  end
end
