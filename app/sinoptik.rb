require 'mechanize'

class SinoptikWeatherApp
  WEATHER_APP_URI = 'http://weather.sinoptik.bg/'.freeze

  def initialize
    @agent = Mechanize.new
  end

  def weather(city)
    weather_page = get_weather_page(city)

    return nil unless weather_page

    found_city = weather_page.css('h1.currentCity')
    current_temperature = weather_page.css('span.wfCurrentTemp')
    current_feel_temperature = weather_page.css('span.wfCurrentFeelTemp')
    current_weather_state = weather_page.css('div.wfCurrentContent > strong')

    [
      found_city,
      current_temperature,
      current_feel_temperature,
      current_weather_state
    ].map { |elem| elem.map(&:text).first.strip }
  end

  private

  def get_weather_page(city)
    @agent.get(WEATHER_APP_URI)

    search_form = @agent.page.form_with(method: 'GET')
    search_form.q = city

    landing_page = @agent.submit(search_form)

    on_search_result_page = landing_page.css('span.wfCurrentTemp').empty?
    if on_search_result_page
      landing_page = redirect_to_weather_page(landing_page)
    end

    landing_page
  end

  def redirect_to_weather_page(current_page)
    existing_search_results = !current_page.css('div.searchCol li a').empty?
    return nil unless existing_search_results

    @agent.click(@agent.page.link_with(text: /\n/))
  end
end
