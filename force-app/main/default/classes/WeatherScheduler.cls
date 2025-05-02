global class WeatherScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        WeatherService.fetchWeatherData();
    }
}