module ApplicationHelper
  def html_lang
    I18n.locale == I18n.default_locale ? "en" : I18n.locale.to_s
  end
end
