module ImdbInterface

  def get_actors(film_page)
    return [] unless film_page.css('table').css('tr.even') && film_page.css('table').css('tr.odd')
    puts "** Get actors **"
    actor_links = []
    nodes = film_page.css('table').css('tr.even')[0..9] + film_page.css('table').css('tr.odd')[0..9]
    nodes.each { |n| actor_links << n.children.first.children.first.attributes['href'].value.gsub('/', '').gsub('name', '') }

    return actor_links
  end

  def get_film_page(link)
    Nokogiri::HTML(open("http://www.imdb.com#{link}fullcredits"))
  end

  def get_actor_page(actor_id)
    Nokogiri::HTML(open("http://www.imdb.com/name/#{actor_id}"))
  end

  def get_films(actor_page)
    return [] unless actor_page.css("div#filmo-head-#{@gen_attr}").children[4]
    puts "** Get films **"
    title_nodes = actor_page.css("div#filmo-head-#{@gen_attr}").children[4].text
    titles_count = title_nodes.scan(/\d/).join('').to_i
    films = actor_page.css("div.filmo-row")[0..(titles_count - 1)]
  end

end

