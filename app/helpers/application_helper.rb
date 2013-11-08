module ApplicationHelper
  def accepted_languages
    languages = [['', nil]]
    Settings.accepted_languages.each_with_index{|language,index| languages << [language,index]}
    languages
  end

  def nav_item name, path
    if current_page? path
      @title = name
    end
    content_tag('li', :class=>(current_page?(path) ? 'active' : nil) ){link_to(name,path)}
  end

  def local_time time
    time.in_time_zone(Settings.default_time_zone).strftime Settings.time_format
  end
end
