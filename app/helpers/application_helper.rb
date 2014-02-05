module ApplicationHelper
  def cdn_jquery
    [ javascript_include_tag("//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"),
      javascript_tag("window.jQuery || document.write(unescape('#{javascript_include_tag(:jquery).gsub('<','%3C')}'))")
    ].join("\n").html_safe
  end
end
