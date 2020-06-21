# This file was generated, do not modify it. # hide
data_repo = "https://raw.githubusercontent.com/tlienart/DataScienceTutorialsData.jl/master/data"

url_power   = data_repo * "/power_syst/DE_power_hourly.csv"
url_weather = data_repo * "/power_syst/DE_weather_data.csv"

power   = DataFrame(urldownload(url_power))
weather = DataFrame(urldownload(url_weather));