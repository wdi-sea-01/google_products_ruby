#RUBY!! no more semi-colons... ever.

require 'json'
file = File.read("./products.json")

#Welcome to RUBY we use snake case now
#snake case word_word not camel case wordWord
google_data = JSON.parse(file)


def get_shopping_products items
    items.select do |item|
        item['kind']=="shopping#product"
    end
end

def get_backorder_products items
    items.select do |item|
        backorders = item['product']['inventories'].select do |inv_item|
            inv_item['availability']=='backorder'
        end
        backorders.length > 0
    end
end

def get_multiple_images items
    items.select do |item|
        item['product']['images'].length > 1
    end
end

def get_cannon_items items
    items.select do |item|
        item['product']['brand'].casecmp("canon") == 0
    end
end

def get_brand_ebay items
    items.select do |item|
        item['product']['author']['name'].casecmp("ebay") < 1
    end
end

def output_items items
    items.each do |item|
        puts "brand:  #{item['product']['brand']}"
        puts "price:  $#{item['product']['inventories'].first['price']}"
        puts "image count: #{item['product']['images'].length}"
        item['product']['images'].each_with_index do |image,index|
            puts "image #{index}: #{image['link']}"
        end
        # print first image only
        # puts "image:  #{item['product']['images'].first['link']}"
        puts " "
    end
end



items = google_data['items']

case ARGV.first.to_i

when 1
    puts "shopping#product item count: #{get_shopping_products(items).length}"
when 2
    puts "items on backorder: #{get_backorder_products(items).length}"
    output_items get_backorder_products(items)
when 3
    puts "items with multiple images: #{get_multiple_images(items).length}"
    output_items get_multiple_images(items)
when 4
    puts "cannon items: #{get_cannon_items(items).length}"
    output_items get_cannon_items(items)
when 5
    cannon_items = get_cannon_items(items)
    puts "ebay items: #{get_brand_ebay(items).length}"
    puts "cannon and ebay items: #{get_brand_ebay(cannon_items).length}"
    output_items get_brand_ebay(cannon_items)
when 6
    output_items items
else
    puts "Enter a number 1 - 6"
    puts "Example: ruby google_shopping.rb 1"
end

#outputs the first item's title
#puts google_data["items"][0]["product"]["title"]