require 'nokogiri'
require 'open-uri'
require_relative 'view'
require_relative 'recipe'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    recipes = @cookbook.all
    @view.display(recipes)
  end

  def create
    recipe_data = @view.ask_for_recipe
    recipe = Recipe.new(recipe_data[0], recipe_data[1], recipe_data[2])
    @cookbook.add_recipe(recipe)
  end

  def import
    # Ask user for ingredient
    ingredient = @view.ask_user_for_ingredient
    # Interpolate ingredient into url
    url = "https://www.allrecipes.com/search/results/?search=#{ingredient}"
    # Send URL to our special scraper method, get back details of each recipe, store in recipe_details variable
    recipe_details = scrape_recipe_details(url)
    # Send recipe details to front end to query user
    index = @view.ask_user_which_recipe(recipe_details)
    # Use user input index to choose corresponding recipe_detail group
    user_choice = recipe_details[index]
    # Create a Recipe instance from selected group of recipe details
    recipe = Recipe.new(user_choice[0], user_choice[1], user_choice[2])
    # Add new recipe to cookbook
    @cookbook.add_recipe(recipe)
  end

  def scrape_recipe_details(url)
    # Nokogiri on the url we pass in, when calling the method on line 29
    doc = Nokogiri::HTML(URI.open(url).read, nil, 'utf-8')
    # create empty array to store out details, to be returned at end of method
    recipe_details = []
    # Search through the doc with our css class selector
    doc.search('.card__detailsContainer').first(5).each do |element|
      # We find the name
      name = element.search('h3').text.strip
      # We find the summary
      description = element.search('.card__summary').text.strip
      # We find the link to the detailed recipe page, and store it in href
      href = element.search('.card__titleLink').attribute('href').value
      # We send our link (href) to a new method that will scrape the prep_time from the detailed recipe page
      prep_time = scrape_prep_time(href)
      # We store the 3 scraped details into an array, push those into ANOTHER array (recipe_details)
      recipe_details << [name, description, prep_time]
    end
    # We send back recipe_details, to be used in our import method
    return recipe_details
  end

  def scrape_prep_time(url)
    # Nokogiri on the url we pass in, when calling the method on line 54
    doc = Nokogiri::HTML(URI.open(url).read, nil, 'utf-8')
    # We send back the prep time
    return doc.search('.recipe-meta-item-body').first.text.strip
  end

  def mark_recipe_as_done
    # we list all recipes (for a better user experience)
    list
    # We tell the view to ask the user to pick a recipe index
    index = @view.which_recipe_to_complete
    # We find corresponding recipe in cookbook repository
    recipe = @cookbook.all[index]
    # we call on the cookbook to mark the recipe as done
    # This way we can also save to csv after marking it
    @cookbook.mark_recipe_as_done(recipe)
  end

  def destroy
    list
    index = @view.what_do_you_want_to_destroy
    @cookbook.remove_recipe(index)
  end
end
