require 'csv'

class Cookbook
  def initialize(file_path)
    @file_path = file_path
    @recipes = []
    load_csv
  end

  def all
    return @recipes
  end

  def add_recipe(new_recipe)
    @recipes << new_recipe
    save_to_csv
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    save_to_csv
  end

  # New method to mark recipe as done
  def mark_recipe_as_done(recipe)
    # call recipe instance method mark_as_done
    recipe.mark_as_done
    # Save updated recipe to csv
    save_to_csv
  end

  def load_csv
    CSV.foreach(@file_path) do |row|
      completed = row[3] == 'true' ? 'true' : 'false'
      recipe = Recipe.new(row[0], row[1], row[2], completed)
      @recipes << recipe
    end
  end

  def save_to_csv
    csv_options = { col_sep: ',', quote_char: '"' }
    CSV.open(@file_path, 'wb', csv_options) do |csv_row|
      @recipes.each do |recipe|
        csv_row << [
          recipe.name,
          recipe.description,
          recipe.prep_time,
          recipe.completed
        ]
      end
    end
  end
end
