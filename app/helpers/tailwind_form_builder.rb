class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    label_text = options.delete(:label) || method.to_s.humanize
    placeholder = options.delete(:placeholder)
    wrapper_class = options.delete(:wrapper_class) || ""

    @template.content_tag :div, class: wrapper_class do
      styled_label(method, label_text) +
      super(method, styled_field_options(options.merge(placeholder: placeholder), method)) +
      error_message(method)
    end
  end

  def email_field(method, options = {})
    label_text = options.delete(:label) || method.to_s.humanize
    placeholder = options.delete(:placeholder)
    wrapper_class = options.delete(:wrapper_class) || ""

    @template.content_tag :div, class: wrapper_class do
      styled_label(method, label_text) +
      super(method, styled_field_options(options.merge(placeholder: placeholder), method)) +
      error_message(method)
    end
  end

  def telephone_field(method, options = {})
    label_text = options.delete(:label) || method.to_s.humanize
    placeholder = options.delete(:placeholder)
    wrapper_class = options.delete(:wrapper_class) || ""

    @template.content_tag :div, class: wrapper_class do
      styled_label(method, label_text) +
      super(method, styled_field_options(options.merge(placeholder: placeholder), method)) +
      error_message(method)
    end
  end

  def number_field(method, options = {})
    label_text = options.delete(:label) || method.to_s.humanize
    placeholder = options.delete(:placeholder)
    wrapper_class = options.delete(:wrapper_class) || ""

    @template.content_tag :div, class: wrapper_class do
      styled_label(method, label_text) +
      super(method, styled_field_options(options.merge(placeholder: placeholder), method)) +
      error_message(method)
    end
  end

  def text_area(method, options = {})
    label_text = options.delete(:label) || method.to_s.humanize
    placeholder = options.delete(:placeholder)
    wrapper_class = options.delete(:wrapper_class) || ""
    rows = options.delete(:rows) || 3

    @template.content_tag :div, class: wrapper_class do
      styled_label(method, label_text) +
      super(method, styled_field_options(options.merge(placeholder: placeholder, rows: rows), method)) +
      error_message(method)
    end
  end

  def select(method, choices, options = {}, html_options = {})
    label_text = options.delete(:label) || method.to_s.humanize
    wrapper_class = html_options.delete(:wrapper_class) || ""

    @template.content_tag :div, class: wrapper_class do
      styled_label(method, label_text) +
      super(method, choices, options, styled_field_options(html_options, method)) +
      error_message(method)
    end
  end

  private

  def styled_label(method, text)
    label(method, text, class: "block text-sm font-medium text-gray-700 dark:text-gray-300")
  end

  def styled_field_options(options = {}, method = nil)
    has_errors = method && @object && @object.errors[method].any?

    if has_errors
      default_classes = "mt-1 block w-full border-2 border-red-400 dark:border-red-400 bg-red-50 dark:bg-red-900/20 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-2 focus:ring-red-500 focus:border-red-500 text-base px-3 py-2"
    else
      default_classes = "mt-1 block w-full border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 text-base px-3 py-2"
    end

    if options[:class]
      options[:class] = "#{default_classes} #{options[:class]}"
    else
      options[:class] = default_classes
    end

    options
  end

  def error_message(method)
    return "" unless @object && @object.errors[method].any?

    @template.content_tag :div, class: "mt-1 text-sm text-red-600 dark:text-red-400" do
      @object.errors[method].first
    end
  end
end
