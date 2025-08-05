class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    label_text = options.delete(:label) || method.to_s.humanize
    placeholder = options.delete(:placeholder)
    wrapper_class = options.delete(:wrapper_class) || ""

    @template.content_tag :div, class: wrapper_class do
      styled_label(method, label_text) +
      super(method, styled_field_options(options.merge(placeholder: placeholder)))
    end
  end

  def email_field(method, options = {})
    label_text = options.delete(:label) || method.to_s.humanize
    placeholder = options.delete(:placeholder)
    wrapper_class = options.delete(:wrapper_class) || ""

    @template.content_tag :div, class: wrapper_class do
      styled_label(method, label_text) +
      super(method, styled_field_options(options.merge(placeholder: placeholder)))
    end
  end

  def telephone_field(method, options = {})
    label_text = options.delete(:label) || method.to_s.humanize
    placeholder = options.delete(:placeholder)
    wrapper_class = options.delete(:wrapper_class) || ""

    @template.content_tag :div, class: wrapper_class do
      styled_label(method, label_text) +
      super(method, styled_field_options(options.merge(placeholder: placeholder)))
    end
  end

  def number_field(method, options = {})
    label_text = options.delete(:label) || method.to_s.humanize
    placeholder = options.delete(:placeholder)
    wrapper_class = options.delete(:wrapper_class) || ""

    @template.content_tag :div, class: wrapper_class do
      styled_label(method, label_text) +
      super(method, styled_field_options(options.merge(placeholder: placeholder)))
    end
  end

  def text_area(method, options = {})
    label_text = options.delete(:label) || method.to_s.humanize
    placeholder = options.delete(:placeholder)
    wrapper_class = options.delete(:wrapper_class) || ""
    rows = options.delete(:rows) || 3

    @template.content_tag :div, class: wrapper_class do
      styled_label(method, label_text) +
      super(method, styled_field_options(options.merge(placeholder: placeholder, rows: rows)))
    end
  end

  def select(method, choices, options = {}, html_options = {})
    label_text = options.delete(:label) || method.to_s.humanize
    wrapper_class = html_options.delete(:wrapper_class) || ""

    @template.content_tag :div, class: wrapper_class do
      styled_label(method, label_text) +
      super(method, choices, options, styled_field_options(html_options))
    end
  end

  private

  def styled_label(method, text)
    label(method, text, class: "block text-sm font-medium text-gray-700 dark:text-gray-300")
  end

  def styled_field_options(options = {})
    default_classes = "mt-1 block w-full border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 text-base px-3 py-2"

    if options[:class]
      options[:class] = "#{default_classes} #{options[:class]}"
    else
      options[:class] = default_classes
    end

    options
  end
end
