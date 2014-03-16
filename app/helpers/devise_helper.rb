module DeviseHelper

  def devise_error_messages!
    return '' if resource.errors.empty?
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg, :class => "error-message") }.join
    html = <<-HTML
      <ul>
        #{messages}
      </ul>
    HTML
    html.html_safe
  end
end
