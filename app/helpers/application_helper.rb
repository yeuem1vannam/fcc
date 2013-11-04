module ApplicationHelper
  def accepted_languages
    languages = [['', nil]]
    Settings.accepted_languages.each_with_index{|language,index| languages << [language,index]}
    languages
  end
end
