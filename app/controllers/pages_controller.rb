class PagesController < ApplicationController

  require 'watir'

  def home
    esprit_all
  end

  def esprit_all
    @esprit = []
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
    @browser.element(css: '#product-tile-list').children.each do | li |
      li.element(css: '.product-image-container').scroll.to :bottom
      product = {}
      if (li.inner_html.include? "hc-color-thumb-container") && (li.text.downcase.include? "organic")
        product[:description] = li.element(css: '.product-description').text
        if li.element(css: '.reduced-price').exists?
          product[:reduced_price] = li.element(css: '.reduced-price').text
        end
        product[:price] = li.element(css: '.basic-price').text
        product[:colours] = []
        li.element(css: '.hc-color-thumb-container').children.each do | colour |
          product[:colours] << colour.element(css: 'span.hc-tooltip').inner_html
        end
        product[:image_url] = li.element(css: '.product-image-container a .product-image-view').attribute_value('src')
        product[:product_url] = li.element(css: '.product-info-container a').attribute_value('href')
        @esprit << product
      end
    end
  end

end