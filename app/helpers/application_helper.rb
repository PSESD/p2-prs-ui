module ApplicationHelper
  
  # Simple wrapper for inserting a glyphicon
  def glyph(key, text = "")
    content_tag(:span, "", { :class => "glyphicon glyphicon-#{key.to_s}", "aria-hidden" => "true", "aria-label" => text } )
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

  def breadcrumbs(*args)
    content_tag(:ol, class: "breadcrumb") do
      for arg in args
        if arg.is_a?(String)
          concat content_tag(:li, arg, class: "active")
        elsif arg.is_a?(Symbol)
          concat content_tag(:li, link_to(arg.to_s.titleize, arg))
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
  
end
