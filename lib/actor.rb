require_relative 'interface'

class Actor
  require 'open-uri'
  require 'nokogiri'
  include ImdbInterface

  # Need gender attribute b/c imdb's css uses the words 'actor' / 'actress'
  attr_accessor :id, :connector_id, :name, :gen_attr

  def initialize(id, connector_id, name, gender='M')
    @id = id
    @connector_id = connector_id
    @name = name
    @gen_attr = gender == 'M' ? 'Actor' : 'Actress'
  end

  def actor?(id)
    !id.to_s.scan("nm").first.nil?
  end

  def film?(id)
    !id.to_s.scan("tt").first.nil?
  end

  def movie_distance
    # Using a graph traversal with breadth-first search
    #                     1
    #                   2   3
    #                 4   5   6
    # Adding all of the actor's films as nodes
    # Traversing all of those and adding all actors as nodes
    # For each actor node, scanning their entire filmography for the 'connector id'
    # If it is not found, queueing all of the actors in this film and repeating the loop
    # It will return false if there is no link between actors, but this could take hours!

    @visited = {}
    queue = []
    queue << [@id, 0]

    while queue.length > 0
      node = queue.shift
      id = node[0]
      distance = node[1]

      if actor?(id) && @visited[id].nil?
        @visited[id] = 1
        actor_page = get_actor_page(id)
        films = get_films(actor_page)
        return (distance + 1) if scan_filmography(films)
        films.each{ |f| queue << [get_film_link(f), (distance + 1)] }
      elsif film?(id) && @visited[id].nil?
        @visited[id] = 1
        film_page = get_film_page(id)
        actors = get_actors(film_page)
        actors.each{ |a| queue << [a, distance] } unless actors == false
      end
    end

    return false
  end

  # Selector to get link href from page
  def get_film_link(f)
    f.css('a').first.attributes['href'].value
  end

  # Scans to see if the actor id appears in the "connector's" films
  def scan_filmography(films)
    films.each do |f|
      film_page = get_film_page(get_film_link(f))
      return true if film_page.to_s.scan("#{@connector_id}").first
    end

    return false
  end

end

