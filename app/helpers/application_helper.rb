module ApplicationHelper
  def html_lang
    I18n.locale == I18n.default_locale ? "en" : I18n.locale.to_s
  end

  def markdown(text)
    return "" if text.blank?

    renderer = Redcarpet::Render::HTML.new(
      filter_html: true,
      no_links: false,
      no_images: false,
      no_styles: true,
      safe_links_only: true,
      with_toc_data: false,
      hard_wrap: true
    )

    markdown = Redcarpet::Markdown.new(renderer,
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true,
      superscript: true,
      underline: true,
      highlight: true,
      quote: true,
      footnotes: true,
      space_after_headers: true,
      no_intra_emphasis: true
    )

    # First render the markdown
    result = markdown.render(text)

    # Then process GitHub-style task lists in the rendered HTML
    result = process_task_lists_in_html(result)

    result.html_safe
  end

  private

  def process_task_lists_in_html(html)
    # Convert GitHub-style task lists in rendered HTML
    # This handles both top-level and nested task lists
    result = html

    # Keep processing until no more matches are found (handles nested structures)
    while result.match(/<li[^>]*>\s*\[([ x])\]\s+(.*?)<\/li>/mi)
      result = result.gsub(/<li[^>]*>\s*\[([ x])\]\s+(.*?)<\/li>/mi) do |match|
        checked = $1 == "x"
        content = $2

        checkbox_html = if checked
          '<input type="checkbox" class="task-list-item-checkbox" checked disabled>'
        else
          '<input type="checkbox" class="task-list-item-checkbox" disabled>'
        end

        "<li class=\"task-list-item\">#{checkbox_html} #{content}</li>"
      end
    end

    result
  end
end
