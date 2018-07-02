require 'mechanize'

class WeatherApp
  REQUEST_RETRY_LIMIT = 5
  REQUEST_SECONDS_DELAY = 2
  WEATHER_APP_URI = ''.freeze

  def initialize
    @agent = Mechanize.new
  end

  def weather(city)
    weather_page = error_handler { get_weather_page(city) }

    raise ArgumentError, 'City not found' unless weather_page

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

  def error_handler
    retry_count = 0

    begin
      yield
    rescue SocketError
      raise if retry_count > REQUEST_RETRY_LIMIT

      sleep REQUEST_SECONDS_DELAY

      retry_count += 1

      retry
    end
  end

  def get_weather_page(city); end

  def redirect_to_weather_page(current_page); end
end
