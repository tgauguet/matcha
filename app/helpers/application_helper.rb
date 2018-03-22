module ApplicationHelper

  def this_page?(val)
    request.path.gsub!("/", "") == val
  end

  def get_image(img)
    current_user[img] ? current_user[img] : 'empty.png'
  end

end
