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
    @browser = Watir::Browser.new
    @browser.goto('https://www.esprit.co.uk/search?query=organic')
    @browser.element(css: '#product-tile-list').children.each_with_index do | li, i |
      li.scroll.to :center
      i = {}
      i[:description] = li.element(css: '.product-description').text
      i[:price] = li.element(css: '.basic-price').text
      i[:colours] = []
      li.element(css: '.hc-color-thumb-container').children.each do | colour |
        i[:colours] << colour.element(css: 'span.hc-tooltip').inner_html
      end
      i[:image_url] = li.element(css: '.product-image-container a .product-image-view').attribute_value('src')
      i[:product_url] = li.element(css: '.product-info-container a').attribute_value('href')
      @esprit << i
    end
    @browser.close
  end

end