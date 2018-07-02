require_relative 'weather'

class SinoptikWeatherApp < WeatherApp
  WEATHER_APP_URI = 'http://weather.sinoptik.bg/'.freeze

  def initialize
    super

    @city_selector = 'h1.currentCity'
    @temp_selector = 'span.wfCurrentTemp'
    @feel_temp_selector = 'span.wfCurrentFeelTemp'
    @weather_state = 'div.wfCurrentContent > strong'
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
