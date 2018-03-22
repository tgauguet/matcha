module SortHelper

  def generate_users_list(params)
    params['id'] = current_user.id
    params['interested_in'] = current_user.interested_in
    list = generate_tags_list(params["tags"])
    @users = generate_array(params)
    @users = @users.select { |u| tags_match(list,u.to_dot.id) > 0 } if list
    @users = @users.select { |u| get_distance(loc_params(u)) <= params['location'].to_i } if params['location']
    @count = @users.count
  end

  def generate_array(params)
    if params["personalized"]
      return User.personalized(params)
    end
    params['gender'] ? User.all_according_to(params) : User.all(current_user.id)
  end

  def paginate(params)
    @users = filtered_users(params['order'])
    @per_page = params['per_page'] ? params['per_page'].to_i : 20
    @page_count = @per_page < 1 ? 20 : @count / @per_page
    @page = set_page(params['page'].to_i, @page_count)
    min = @page == 1 ? 0 : ((@page - 1) * @per_page + 1)
    max = @page == 1 ? (@per_page - 1) : min + (@per_page - 1)
    @users = @users[min..max]
  end

  def filtered_users(order)
    @users.sort_by do |u|
      if (order == "age" || order == "public_score" || order == "id")
        u[order]
      elsif order == "tags"
        tags_count(u.to_dot.id)
      elsif order == "location"
        get_distance(loc_params(u))
      end
    end
	end

  def get_distance(user)
    current = []
    current[0] = current_user['latitude']
    current[1] = current_user['longitude']
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (user[0]-current[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (user[1]-current[1]) * rad_per_deg
    lat1_rad, lon1_rad = current.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = user.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    res = rm * c / 1000
    res.to_i # Delta in meters
  end

  def tags_count(user)
    Tagging.matchs(current_user.id, user).count
  end

  def generate_tags_list(tags)
    list = []
    return nil if !tags
    tags = tags.split(/\s*,\s*/)
    tags.each do |tag|
      v = Tag.exists?(tag)
      list << v["id"] if (v && !list.include?(v["id"]))
    end
    list.empty? ? nil : list
  end

  def tags_match(list, user)
    Tagging.selection_match(current_user.id, user, list).count
  end

  def set_page(page, count)
    (page > count || page < 1) ? 1 : page
  end

  def next_page(page, page_count, count, per_page)
    "<input type='submit' value='#{page+1}' name='page'/>" unless (page == page_count || count < per_page)
  end

  def previous_page(page)
    "<input type='submit' value='#{page-1}' name='page'/>" unless page == 1
  end

  def loc_params(user)
    [user.to_dot.latitude, user.to_dot.longitude]
  end

  def gender_is_given(val, match)
    if val.blank? && match == 'B'
      'checked'
    else
      'checked' if val == match
    end
  end

  def location_is_given(val, match)
    'selected' if val == match
  end

end
