class PagesController < ApplicationController

  require 'watir'

  def home
    # @description_array = []
    # @browser = Watir::Browser.new
    # @browser.goto('https://www.esprit.co.uk/search?query=organic')
    # @browser.element(css: '#product-tile-list').children.each do | li |
    #   @description_array << "Description: #{li.element(css: '.product-description').text}"
    # end
    # @browser.close
    esprit_all
  end

  def esprit_all
    @esprit = []
    @product_list = []
    @browser = Watir::Browser.new
    @browser.goto('https://www.esprit.co.uk/search?query=organic')
    @number_of_pages = @browser.element(css: '#pov-paging').children.count - 2

    esprit_cycle_through_list
    @number_of_pages.times do
      @browser.element(css: '#pov-paging li.next').click
      esprit_cycle_through_list
    end
    @browser.close
  end

  def esprit_cycle_through_list
    @browser.element(css: '#product-tile-list').children.each_with_index do | li, i |
      li.element(css: '.product-image-container').scroll.to :bottom
      i = {}
      if li.inner_html.include? "hc-color-thumb-container"
        i[:description] = li.element(css: '.product-description').text
        if li.element(css: '.reduced-price').exists?
          i[:reduced_price] = li.element(css: '.reduced-price').text
        end
        i[:price] = li.element(css: '.basic-price').text
        i[:colours] = []
        li.element(css: '.hc-color-thumb-container').children.each do | colour |
          i[:colours] << colour.element(css: 'span.hc-tooltip').inner_html
        end
        i[:image_url] = li.element(css: '.product-image-container a .product-image-view').attribute_value('src')
        i[:product_url] = li.element(css: '.product-info-container a').attribute_value('href')
        @esprit << i
      end
    end
    binding.pry
  end

end