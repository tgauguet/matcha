module SortHelper

  def paginate(users, page, per_page)
    @page_count = per_page < 1 ? 20 : users.count / per_page
    @page = set_page(page.to_i, @page_count)
    @min = @page == 1 ? 0 : ((@page - 1) * per_page + 1)
    @max = @page == 1 ? (per_page - 1) : @min + (per_page - 1)
    @users = users[@min..@max]
  end

  def get_distance(current, user)
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

  def set_page(page, count)
    (page > count || page < 1) ? 1 : page.to_i
  end

  def next_page(page, page_count, per_page, order)
    "<a href='http://localhost:4567/?page=#{page+1}#{use(per_page)}#{get_order(order)}'>Suivante</a>" unless page == page_count
  end

  def previous_page(page, per_page, order)
    "<a href='http://localhost:4567/?page=#{page-1}#{use(per_page)}#{get_order(order)}'/>Précédente</a>" unless page == 1
  end

  def use(per_page)
    per_page.to_i == 20 ? "" : "&per_page=#{per_page}"
  end

  def get_order(order)
    order ? "&order=#{order}" : ""
  end

  def full_order
    @total_users = User.all(current_user.id)
    @total_users.sort_by { |u| [u['interested_in'], get_distance(user_location,loc_params(u)), tags_count(u.to_dot.id), u['public_score']] }
  end

  def set_order(order)
		if order == "age" || order == "public_score" || order == "id"
			@total_users.sort_by { |u| u[order] }
		elsif order == "tags"
			@total_users.sort_by { |u| tags_count(u.to_dot.id) }.reverse
		elsif order == "location"
			@total_users.sort_by { |u| get_distance(user_location,loc_params(u)) }
		else
			@total_users.sort_by { |u| u['id'] }
		end
	end

  def user_location
    [current_user['latitude'], current_user['longitude']]
  end

  def loc_params(user)
    [user.to_dot.latitude, user.to_dot.longitude]
  end

end
