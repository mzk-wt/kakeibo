module ApplicationHelper

  def th_tag(text, options = {})
    options = {sort: false, filter: false}.merge(options)
    
    content_tag :th do
      concat (content_tag :div, text)
      if options[:sort] then
        concat (content_tag :div, 'sort')
      end
      if options[:filter] then
        concat (content_tag :div, 'filter')
      end
    end
  end
end
