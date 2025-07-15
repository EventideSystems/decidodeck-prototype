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
      footnotes: true
    )

    markdown.render(text).html_safe
  end
end
