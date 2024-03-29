# frozen_string_literal: true

module Shark
  module MailingService
    class Mailer
      class << self
        attr_writer :layout, :template_root

        def layout
          @layout || MailingService.config.default_layout
        end

        def method_missing(method, *args, &block)
          return super unless respond_to?(method)

          instance = new(
            layout: layout,
            template_name: method.to_s,
            template_path: File.join(template_root.to_s, name.underscore)
          )
          instance.send(method, *args)
          instance
        end

        def template_root
          @template_root || MailingService.config.default_template_root
        end

        protected

        def respond_to_missing?(method, include_private = false)
          known_methods = if include_private
                            instance_methods(false)
                          else
                            public_instance_methods(false)
                          end
          known_methods.include?(method)
        end
      end

      attr_reader :layout, :template_name, :template_path

      def initialize(layout:, template_path:, template_name:)
        @layout = layout
        @template_name = template_name
        @template_path = template_path
      end

      def deliver
        @mail.save
      end
      alias deliver_now deliver

      protected

      def body(format, locals = {})
        renderer.render(template_name, format, locals)
      end

      def attribute_with_default(attributes, attribute)
        return attributes[attribute] if attributes.key?(attribute)

        I18n.t!("#{self.class.name.underscore}.#{template_name}.#{attribute}")
      rescue StandardError
        nil
      end

      def mail(attributes)
        locals = attributes[:locals] || {}
        mail_attributes = {
          layout: attributes[:layout] || layout,
          reply_to: attributes[:reply_to],
          recipient: attributes[:to],
          subject: attribute_with_default(attributes, :subject),
          header: attribute_with_default(attributes, :header),
          sub_header: attribute_with_default(attributes, :sub_header),
          html_body: body(:html, locals),
          text_body: body(:text, locals),
          attachments: attributes[:attachments] || {}
        }
        %i[from header_image reply_to unsubscribe_url].each do |key|
          value = attributes[key]
          mail_attributes[key] = value if value.present?
        end

        @mail = Shark::MailingService::Mail.new(mail_attributes)
      end

      def renderer
        @renderer ||= Renderers::ErbRenderer.new(template_path)
      end
    end

    module Mailers
      BaseMailer = MailingService::Mailer
    end
  end
end
