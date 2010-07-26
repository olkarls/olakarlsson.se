# Helper methods defined here can be accessed in any controller or view in the application

Presto.helpers do
  def body_classes
    classes = []
    classes << 'home' if request.path == "/"
    classes << @page.template if @page and @page.template
    classes << "page-#{@page.heading.downcase.gsub(/\s/, '-')}" if @page
    classes
  end
  
  def widont(string)
    words = string.split(" ")
    last_word = words.pop
    words.join(" ") + "&nbsp;" + last_word
  end
  
  def theme_partial(partial, options={})
    partial "themes/#{Nesta::Config.theme}/#{partial}", options
  end
  
  def nesta_atom_id_for_page(page)
    published = page.date.strftime('%Y-%m-%d')
    "tag:#{request.host},#{published}:#{page.abspath}"
  end
  
  def atom_id(page = nil)
    if page
      page.atom_id || nesta_atom_id_for_page(page)
    else
      "tag:#{request.host},2009:/"
    end
  end
  
  def url_for(page)
    File.join(base_url, page.path)
  end
  
  def base_url
    url = "http://#{request.host}"
    request.port == 80 ? url : url + ":#{request.port}"
  end
  
  def absolute_urls(text)
    text.gsub!(/(<a href=['"])\//, '\1' + base_url + '/')
    text
  end
  
  def format_date(date)
    date.strftime("%d %B %Y")
  end
end