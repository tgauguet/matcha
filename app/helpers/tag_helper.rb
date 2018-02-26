module TagHelper

  def get_content(id)
    "#" + Tag.find_by_id(id).to_dot.content.force_encoding("UTF-8")
  end

end
