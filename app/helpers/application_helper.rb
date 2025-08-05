module ApplicationHelper
  def initials_for(name)
    return "?" if name.blank?

    name.split.map(&:first).join.upcase
  end

  def influence_level_text(level)
    return nil if level.blank?

    "#{level.humanize} Influence"
  end

  def interest_level_text(level)
    return nil if level.blank?

    "#{level.humanize} Interest"
  end

  def influence_level_badge(person)
    return "" unless person.respond_to?(:influence_level) && person.influence_level.present?

    text = influence_level_text(person.influence_level)
    return "" if text.nil?

    content_tag :span, text,
      class: "inline-flex items-center px-2 py-1 rounded-md text-xs font-medium bg-red-100 dark:bg-red-900/30 text-red-800 dark:text-red-400"
  end

  def interest_level_badge(person)
    return "" unless person.respond_to?(:interest_level) && person.interest_level.present?

    text = interest_level_text(person.interest_level)
    return "" if text.nil?

    content_tag :span, text,
      class: "inline-flex items-center px-2 py-1 rounded-md text-xs font-medium bg-yellow-100 dark:bg-yellow-900/30 text-yellow-800 dark:text-yellow-400"
  end

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
          '<input type="checkbox" class="task-list-item-checkbox" checked data-action="change->task-list#toggle">'
        else
          '<input type="checkbox" class="task-list-item-checkbox" data-action="change->task-list#toggle">'
        end

        "<li class=\"task-list-item\">#{checkbox_html} #{content}</li>"
      end
    end

    result
  end
end
