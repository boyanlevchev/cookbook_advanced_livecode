# require 'nokogiri'
# file = 'strawberry.html'  # or 'strawberry.html'
# doc = Nokogiri::HTML(File.open(file), nil, 'utf-8')

# doc.search('.card__detailsContainer').first(5).each do |element|
#   name = element.search('h3').text.strip
#   description = element.search('.card__summary').text.strip
# end
