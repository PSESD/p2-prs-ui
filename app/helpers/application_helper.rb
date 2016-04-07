module ApplicationHelper
  
  # Simple wrapper for inserting a glyphicon
  def glyph(key, text = "", options = {})
    content_tag(:span, "", { :class => "glyphicon glyphicon-#{key.to_s} #{options[:class]}", "aria-hidden" => "true", "aria-label" => text } )
  end
  
  def alert_class_for(flash_type)
    case flash_type.to_s
      when "success"
        "alert-success"   # Green
      when "error"
        "alert-danger"    # Red
      when "alert"
        "alert-warning"   # Yellow
      when "notice"
        "alert-info"      # Blue
      else
        flash_type.to_s
    end
  end

  def prs_dev_label_class
    case Rails.application.secrets.prs_environment.downcase
    when "dev"
      "label-warning"
    when "production"
      "label-success"
    when "prod"
      "label-success"
    else
      "label-default"
    end
  end

  def breadcrumbs(*args)
    content_tag(:ol, class: "breadcrumb") do
      for arg in args
        if arg.is_a?(String)
          concat content_tag(:li, arg, class: "active")
        elsif arg.is_a?(Symbol)
          concat content_tag(:li, link_to(arg.to_s.titleize, arg))
        elsif arg.is_a?(Array)
          concat content_tag(:li, link_to(arg.last.to_s.titleize, arg))
        elsif arg.is_a?(ActiveRestClient::ResultIterator)
          concat(content_tag(:li, class: "dropdown") do
            concat(content_tag(:a, :class => "dropdown-toggle", "data-toggle" => "dropdown") do
              concat(guess_label_text( arg.select{|a| current_page?(a) }))
              concat(" ")
              concat(content_tag(:span, "", class: "caret"))
            end)
            concat(content_tag(:ul, class: "dropdown-menu") do
              for object in arg
                concat(content_tag(:li, link_to(guess_label_text(object), object), class: ("active" if current_page?(object))))
              end
            end)
          end)
        else
          concat content_tag(:li, link_to(guess_label_text(arg), arg))
        end
      end
    end    
  end
  
  def guess_label_text(arg)
    return guess_label_text(arg.last) if arg.is_a?(Array)
    methods = [:to_label, :name, :title]
    label_text = arg.try(methods.find{ |m| arg.respond_to?(m) }) rescue nil
  end

  # Provides a link to display the raw attributes provided in a modal.
  def raw_attributes(object, options = {})
    dom_id = "rawAttributesModal_#{object.hash}"
    options.merge!({ "data-toggle" => "modal", "data-target" =>  "##{dom_id}" })
    link_to(glyph('list-alt') + options[:title], "#", options) + render(
      partial: "layouts/raw_attributes", layout: "layouts/modal", object: object, 
      locals: { id: dom_id, title: "Raw Attributes", dialog_class: 'modal-lg' })
  end
  
  
end
