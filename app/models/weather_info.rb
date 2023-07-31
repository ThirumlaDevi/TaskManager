class WeatherInfo < ApplicationRecord
    require 'net/http'
    self.table_name = "weather_info"
    belongs_to :task, class_name: "Task"

    # define this as class method
    def self.cronTask
        weatherRetriveDate = Date.today + 2
        # find all task not in weather and is 1 days due from today
        # Information is retrieved 1 day before as the longest time difference between 2 places is 16hrs-23hrs
        # Hence, running a cron job every day to populate weather informantion for every second day and that day
        # is more valid
        # check last updated through timestamp
        number_of_task_weather_to_update = totalRecordCount
        while number_of_task_weather_to_update > 0
            tasks = Task.where(:due_date=>Date.today+2).left_outer_joins(:weather_info).limit(10)
            tasks.each do |task|
                user_location_info = UserLocationInfo.find_by(:user_id=>task.user_id)
                if user_location_info.nil?
                    puts "Cron job error user information for task not found #{res.body}"
                else
                    res = callOpenWeather(user_location_info.latitude,user_location_info.longitude)
                    if !res.nil?
                        weatherOutputs = WeatherOutput.new
                        weatherOutputs.from_json(res)
                        weatherOutput = weatherOutputs.list.second # second day forecast
                        temperator = weatherOutput.deg
                        rain = weatherOutput.rain
                        humidity = weatherOutput.humidity
                        windspeed = weatherOutput.speed
                        description = weatherOutput.weather.first.description
                        WeatherInfo.create(:temperator=>temperator, :rain=>rain, :humidity=>humidity, :windspeed=>windspeed, :description=>description, :task_id=>task.id)
                    end
                end
            end

            puts "Weather information updated for #{task.size} tasks"
            # get user and location information and call weather app
            # api key f72cae3edf151c65f4b5b764a79cea3a
            number_of_task_weather_to_update = totalRecordCount
        end
    end

    def self.totalRecordCount
        Task.where(:due_date=>Date.today+2).left_outer_joins(:weather_info).count
    end

    def self.callOpenWeather(lat,lon)
        uri = URI.parse("https://api.openweathermap.org/data/2.5/forecast/daily?lat=#{lat}&lon=#{lon}&cnt=2&appid=f72cae3edf151c65f4b5b764a79cea3a")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        res = http.get(uri.request_uri)
        if res.code.to_i >= 400
            puts "cron job error #{res.body}"
            return nil
        end
        res.body.to_json       
    end
end

# CURL "https://api.openweathermap.org/data/2.5/forecast/daily?lat=35&lon=50&cnt=2&appid=f72cae3edf151c65f4b5b764a79cea3a"