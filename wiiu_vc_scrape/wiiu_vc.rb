require "csv"
require "open-uri"
require "selenium-webdriver"

def make_csv
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_argument("-headless")
  # driver = Selenium::WebDriver.for :firefox, options: options
  driver = Selenium::WebDriver.for :firefox
  url = "https://www.nintendo.co.jp/software/wiiu/index.html?sftab=all"
  driver.navigate.to url

  30.times do
    puts driver.current_url
    sleep 1
    begin
      element = driver.find_element(:xpath, "/html/body/div[1]/div[3]/div/div/div/div[2]/div[2]/div[1]/div[3]/ul")
      li = element.find_elements(:tag_name, "li")
      button = driver.find_element(:class, "nc3-c-pagination__next")

      li.each do |list|
        if !list.text.empty?
          list_text = list.text
          list_a = list.find_element(:tag_name, "a").attribute("href")
          id = URI.parse(list_a).path
          id.slice!("/titles/")
          list_img = list.find_element(:tag_name, "img").attribute("src")
          list_img.slice!("?w=280&h=158")

          if list_text.split("\n")[-1] == "バーチャルコンソール" then
            CSV.open("./wiiu_vc.csv", "a") do |file|
              file << [id] + list_text.split("\n") + [list_a] + [list_img]
            end
          end

        end
      end

      button.click

    rescue => error
      puts error
    end
  end

  driver.quit
end

def add_info
  csv_data = CSV.read("./wiiu_vc.csv")
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_argument("-headless")
  driver = Selenium::WebDriver.for :firefox, options: options

  csv_data.each do |data|
    url = data[6]
    driver.navigate.to url
    begin
      sleep 1
      genre = driver.find_element(:xpath, "/html/body/div[6]/div[3]/div[3]/div/div/div[1]/div/div[2]/div[2]/div/dl[1]/dd")
      element = driver.find_element(:xpath, "/html/body/div[6]/div[3]/div[1]/div/div[3]/div/div/div/div[1]/div/img")
      case element.attribute("src")
      when "https://img-eshop.cdn.nintendo.net/i/63424c8fccb962bcef365f18ac77a12f6a74251c48e57ecdba6160da02605dc0.jpg"
        hardware = "FC"
      when "https://img-eshop.cdn.nintendo.net/i/681a99a652383fd3974526b54da8d0127095ec597082710ac03eeac97a0a1082.jpg"
        hardware = "SFC"
      when "https://img-eshop.cdn.nintendo.net/i/0619a6cc1323dfb009a8f38e0d4ef18e7a8ec8582bfa13b9cffa3af160592d9e.jpg"
        hardware = "N64"
      when "https://img-eshop.cdn.nintendo.net/i/a1103ead570136883367e8b5964925057d5e1816b17be30da234d1d0ebed559e.jpg"
        hardware = "GBA"
      when "https://img-eshop.cdn.nintendo.net/i/b1f2f102f23057048d5bcb9bf2ee0c1e5edf0cc8a8e1ba9d154bd4cf42d59b7c.jpg"
        hardware = "DS"
      when "https://img-eshop.cdn.nintendo.net/i/cd50fb1c797c4d3b2095ce3707cb805e6f4703f7d74b9d8ecb63c5aa0a44189c.jpg"
        hardware = "PCE"
      when "https://img-eshop.cdn.nintendo.net/i/87e3db6fa1bdfb93830e61425d834592a14e88ad4188c7f9652abafae3bad294.jpg"
        hardware = "MSX"
      else
        hardware = ""
      end

      CSV.open("./wiiu_vc_add_info.csv", "a") do |file|
        file << data[0..1] + [hardware] + [genre.text] + data[2..]
      end
    rescue => error
      puts error
    end
  end

  driver.quit
end

def download_image
  csv_data = CSV.read("./wiiu_vc.csv")
  csv_data.each do |data|
    sleep 1
    url_parse = URI.parse(data[7])
    extension = url_parse.path[url_parse.path.index(".")..]
    File.open("./image/#{data[0]}#{extension}", "wb") do |file|
      URI.open(data[7]) do |img|
        file.puts img.read
      end
    end
  end
end

case ARGV[0]
when "make_csv"
  make_csv()
when "add_info"
  add_info()
when "download_image"
  download_image()
end
