module ApplicationHelper
  def cdn_jquery
    [ javascript_include_tag("//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"),
      javascript_tag("window.jQuery || document.write(unescape('#{javascript_include_tag(:jquery).gsub('<','%3C')}'))")
    ].join("\n").html_safe
  end

  def title(page_title)
    content_for(:title) { "Mod: #{page_title}" }
  end

  def sortable(column, title=nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    options   = { sort: column, direction: direction }
    options[:q] = query if query

    link_to title, options, { class: css_class }
  end
end
