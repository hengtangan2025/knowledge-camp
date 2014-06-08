module ApplicationHelper
  def page_title(title)
    content_for :page_title do
      title 
    end
  end
end
