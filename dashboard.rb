require_relative 'app/accuweather'
require_relative 'app/sinoptik'

class Dashboard
  def initialize
    @accu_app = AccuWeatherApp.new
    @sinoptik_app = SinoptikWeatherApp.new
  end

  def show_weather_info(city)
    accu_info = @accu_app.weather(city)
    sinoptik_info = @sinoptik_app.weather(city)

    pretty_print([accu_info, sinoptik_info])
  end

  def pretty_print(weather_info)
    combined_info = weather_info[0].zip(weather_info[1])
    combined_info.map! { |field_array| field_array.uniq.join('/') }

    puts "\nThe information that we found about #{combined_info.shift}:"
    puts combined_info
  end
end

class App
  @dashboard = Dashboard.new

  def self.console_interface
    puts 'Welcome to the Weather App'
    puts 'Please enter the city you want information about:'
    city = gets.chomp

    @dashboard.show_weather_info(city)
  end
end

App.console_interface
