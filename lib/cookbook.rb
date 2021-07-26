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

  def load_csv
    CSV.foreach(@file_path) do |row|
      recipe = Recipe.new(row[0], row[1], row[2], row[3])
      @recipes << recipe
    end
  end

  def save_to_csv
    csv_options = { col_sep: ',', quote_char: '"' }
    CSV.open(@file_path, 'wb', csv_options) do |csv_row|
      @recipes.each do |recipe|
        csv_row << [recipe.name, recipe.description, recipe.prep_time, recipe.completed]
      end
    end
  end
end
