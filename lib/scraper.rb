require 'nokogiri'
require 'open-uri'
require 'pry'

#students: doc.css(".student-card")
#name: student.css("h4").text
#location: student.css("p.student-location").text
#profile url: student.css("a").attribute("href").value

class Scraper
  index_url = "./fixtures/student-site/index.html"

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    doc = Nokogiri::HTML(html)

    students = []

    doc.css(".student-card").each do |student|
      student_info = {
        :name => student.css("h4").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
      students << student_info
    end
    students
  end

  #social icon links: doc.css(".social-icon-container") (an array of 4 anchor tags)
  #to check the value of the links in the array - link: link.css("a").attribute("href").value
  #if link.include? "twitter" // or "linkedin", etc. to check which link is which (blog url would include "flatironschool")
  #profile quote: doc.css(".profile-quote").text
  #bio: doc.css(".description-holder").css("p").text

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    doc = Nokogiri::HTML(html)

    twitter_link = ''
    linkedin_link = ''
    github_link = ''
    blog_link = ''

    student_profile = {}

    links = doc.css(".social-icon-container").css("a")
    links.each do |link|
      link_value = link.attribute("href").value
      if link_value.include? "twitter"
        student_profile[:twitter] = link_value
      elsif link_value.include? "linkedin"
        student_profile[:linkedin] = link_value
      elsif link_value.include? "github"
        student_profile[:github] = link_value
      elsif link_value.include? "flatironschool"
        student_profile[:blog] = link_value
      end
    end

    student_profile[:profile_quote] = doc.css(".profile-quote").text
    student_profile[:bio] = doc.css(".description-holder").css("p").text

    student_profile
  end

end
