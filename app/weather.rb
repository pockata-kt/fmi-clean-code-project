require 'mechanize'

class WeatherApp
  WEATHER_APP_URI = ''.freeze

  def initialize
    @agent = Mechanize.new
  end

  def weather(city)
    weather_page = get_weather_page(city)

    return nil unless weather_page

    found_city = weather_page.css(@city_selector)
    current_temperature = weather_page.css(@temp_selector)
    current_feel_temperature = weather_page.css(@feel_temp_selector)
    current_weather_state = weather_page.css(@weather_state)

    [
      found_city,
      current_temperature,
      current_feel_temperature,
      current_weather_state
    ].map { |elem| elem.map(&:text).first.strip }
  end

  private

  def get_weather_page(city); end

  def redirect_to_weather_page(current_page); end
end
