module SortHelper

  def paginate(users, page, per_page)
    @page_count = per_page < 1 ? 20 : users.count / per_page
    @page = set_page(page.to_i, @page_count)
    @min = @page == 1 ? 0 : ((@page - 1) * per_page + 1)
    @max = @page == 1 ? per_page : @min + (per_page - 1)
    @users = users[@min..@max]
  end

  def set_page(page, count)
    (page > count || page < 1) ? 1 : page.to_i
  end

  def next_page(page, page_count, per_page)
    "<a href='http://localhost:4567/?page=#{page+1}#{use(per_page)}'>Suivante</a>" unless page == page_count
  end

  def previous_page(page, page_count, per_page)
    "<a href='http://localhost:4567/?page=#{page-1}#{use(per_page)}'/>Précédente</a>" unless page == 1
  end

  def use(per_page)
    per_page.to_i == 20 ? "" : "&per_page=#{per_page}"
  end

end
