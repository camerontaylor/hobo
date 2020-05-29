module Dryml
  class Railtie
    class PageTagResolver < ActionView::Resolver

      def initialize(controller)
        @controller = controller
        super()
      end

      def find_templates(name, prefix, partial, details, outside_app_allowed = false)
        tag_name = @controller.dryml_fallback_tag || name.dasherize + '-page'
        method_name = tag_name.to_s.gsub('-', '_')
        details[:virtual_path] = "#{prefix}/#{name}"
        details[:format] = details.delete(:formats).first
        details[:variant] = details.delete(:variants).first
#         details[:handler] = :html
        details.delete(:handlers)
        details.delete(:locale)
        DT.p "find_templates", details
        if Dryml.empty_page_renderer(@controller.view_context).respond_to?(method_name)
          [ActionView::Template.new('', Dryml.page_tag_identifier(@controller.controller_path, tag_name),
                                    Dryml::Railtie::TemplateHandler, details)]
        else
          []
        end
      end

   end
  end
end
