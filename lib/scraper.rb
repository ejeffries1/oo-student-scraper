require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
    attr_accessor :name, :location, :profile_url

    
  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    students = []
    doc.css(".student-card").each do |spec|
      students << {
        :name => spec.css(".student-name").text,
        :location => spec.css(".student-location").text,
        :profile_url => spec.css("a").attr("href").value
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    social_hash = {}
    doc.css(".social-icon-container a").each do |social|
      if social.attr("href").include?("twitter")
        social_hash[:twitter] = social.attr("href")
      elsif social.attr("href").include?("linked")
        social_hash[:linkedin] = social.attr("href")
      elsif social.attr("href").include?("github")
        social_hash[:github] = social.attr("href")
      elsif social.attr("href").include?(".com")
        social_hash[:blog] = social.attr("href")
      end
      #binding.pry
      social_hash[:profile_quote] = doc.css(".profile-quote").text
      social_hash[:bio] = doc.css(".bio-block.details-block .description-holder").text.strip
    end
    social_hash
  end

end

