require 'rest-client'
require 'json'
require 'pry'



# def get_generic_info(character_name, characteristic)
#   response_string = RestClient.get('http://www.swapi.co/api/people/')
#   response_hash = JSON.parse(response_string)
#
#   character_hash = response_hash["results"].find do |character|
#     character["name"].downcase == character_name.downcase
#   end
#
#   puts character_hash ? character_hash : "I couldn't find that character"
# end

def get_character_movies_from_api(character_name)
  #make the web request

  # response_string = RestClient.get('http://www.swapi.co/api/people/')
  # response_hash = JSON.parse(response_string)

  full_character_hash=build_full_list
  character_hash = full_character_hash.find do |character|
    character["name"].downcase == character_name.downcase
    #test_value = response_hash
  end

  film_list = character_hash["films"].collect do |film|
    film_string = RestClient.get(film)
    film_hash = JSON.parse(film_string)
  end


#binding.pry

  # iterate over the response hash to find the collection of `films` for the given
  #   `character`
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `print_movies`
  #  and that method will do some nice presentation stuff like puts out a list
  #  of movies by title. Have a play around with the puts with other info about a given film.
end

# def list_of_all_characters
#   character_array=[]
#
#   while(character_array.length<response_hash["count"])
#     ##keep adding
#   end
#
#
#   response_string = RestClient.get('http://www.swapi.co/api/people/')
#   response_hash = JSON.parse(response_string)
#
#   count = response_hash["count"]
#   full_character_list = response_hash["results"]
#   count == full_character_list.length ? "Good, we have a complete full_character_list" : "We need to keep adding to full_character_list"
# end

def get_characters_from_page(api_page)
  response_string = RestClient.get(api_page)
  response_hash = JSON.parse(response_string)
  response_hash["results"]
end

def build_full_list
  response_string = RestClient.get('http://www.swapi.co/api/people/')
  response_hash = JSON.parse(response_string)

  #The list of all characters, collected from many API pages (hopefully)
  character_list=[]

  #The total number of characters that should eventually be in our list
  total_characters=response_hash["count"]


  current_page=1
  while character_list.length<total_characters
    character_list+=get_characters_from_page("https://www.swapi.co/api/people/?page=#{current_page}")
    current_page+=1
  end
  character_list

end



def print_movies(films)
  # some iteration magic and puts out the movies in a nice list
  films.each do |film|
    puts "Title: " + film["title"]
    puts "Episode ID: " + film["episode_id"].to_s
    puts "Opening crawl: " + film["opening_crawl"][0..40]
  end
end

# def show_characteristic(character, characteristic)
#   get_generic_info(character, characteristic)
# end

def show_character_movies(character)

  films = get_character_movies_from_api(character)
  print_movies(films)

end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
