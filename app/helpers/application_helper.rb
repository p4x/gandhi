require 'pp'

module ApplicationHelper
  def page_title(title)
    raw "<title>#{GANDHI_SETTINGS['app_name']} | #{title}</title>"
  end

  def pp_debug(obj)
    return false unless Rails.env.development?
    output = '<pre>' +
    h(obj.pretty_inspect) +
    '</pre>'
    raw output
  end
end
