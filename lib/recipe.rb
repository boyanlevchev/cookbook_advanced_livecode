class Recipe
  attr_reader :name, :description, :prep_time, :completed

  def initialize(name, description, prep_time, completed = 'false')
    @name = name
    @description = description
    @prep_time = prep_time
    @completed = completed
  end

  def mark_as_done
    @completed = 'true'
  end
end
