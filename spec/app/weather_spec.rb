require_relative '../../app/weather'

RSpec.describe WeatherApp do
  let(:weather_app) { WeatherApp.new }

  describe '#weather' do
    it 'raises ArgumentError if there is no weather_page found' do
      expect(weather_app)
        .to receive(:get_weather_page)
        .with('City')
        .and_return(nil)

      expect do
        weather_app.weather('City')
      end.to raise_error(ArgumentError)
    end
  end

  describe '#error_handler' do
    it 'rescues SocketError REQUEST_RETRY_LIMIT times, before it fails' do
      stub_const('WeatherApp::REQUEST_SECONDS_DELAY', 0.1)

      expect(weather_app)
        .to receive(:get_weather_page)
        .exactly(WeatherApp::REQUEST_RETRY_LIMIT + 1)
        .times
        .with('City')
        .and_raise(SocketError)

      expect do
        weather_app.weather('City')
      end.to raise_error(SocketError)
    end

    it 'raises StandardError immediately' do
      expect(weather_app)
        .to receive(:get_weather_page)
        .once
        .with('City')
        .and_raise(StandardError)

      expect do
        weather_app.weather('City')
      end.to raise_error(StandardError)
    end
  end
end
