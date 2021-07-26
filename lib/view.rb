class View
  def display(recipes)

    recipes.each_with_index do |recipe, index|
      completed = recipe.completed ? "X" : " "
      puts "#{index + 1}. [#{completed}] #{recipe.name} - #{recipe.description} - Prep time: #{recipe.prep_time}"
    end
  end

  def ask_for_recipe
    puts "What is the name of your recipe?"
    name = gets.chomp
    puts "What is the description?"
    description = gets.chomp
    puts "What is the prep time?"
    prep_time = gets.chomp.to_i

    return [name, description, prep_time]
  end

  def what_do_you_want_to_destroy
    puts "What number do you want to destroy?"
    gets.chomp.to_i - 1
  end

  def ask_user_for_ingredient
    puts "What ingredient would you like to search for?"
    gets.chomp
  end

  def ask_user_which_recipe(recipe_details)
    puts "Which number would you like to add?"
    recipe_details.each_with_index do |recipe, index|
      puts "#{index + 1}. #{recipe[0]}"
    end
    gets.chomp.to_i - 1
  end

  def which_recipe_to_complete
    puts "What number do you want to mark as done?"
    gets.chomp.to_i - 1
  end
end
