require_relative 'weather'

class AccuWeatherApp < WeatherApp
  WEATHER_APP_URI = 'https://m.accuweather.com/en/settings'.freeze

  def initialize
    super
    @city_selector = 'h1#location'
    @temp_selector = '.temp'
    @feel_temp_selector = '.ltr'
    @weather_state = 'p.lg-txt'
  end

  private

  def get_weather_page(city)
    @agent.get(WEATHER_APP_URI)

    change_units_to_metric

    search_form = @agent.page.form_with(
      method: 'POST',
      action: 'https://m.accuweather.com/en/search-locations'
    )
    search_form.FreeTextLocation = city
    landing_page = @agent.submit(search_form)

    on_search_result_page = landing_page.title.include?('Find Your Location')
    if on_search_result_page
      landing_page = redirect_to_weather_page(landing_page)
    end

    landing_page
  end

  def change_units_to_metric
    unit_form = @agent.page.form_with(
      method: 'POST',
      action: 'https://m.accuweather.com/en/settings/to-celsius'
    )
    @agent.submit(unit_form)
  end

  def redirect_to_weather_page(current_page)
    existing_search_results = current_page
                              .body
                              .include?('Multiple Locations Found')
    return nil unless existing_search_results

    @agent.click(@agent.page.link_with(text: /^\w/))
  end
end
