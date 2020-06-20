# This file was generated, do not modify it. # hide
data = DataFrame(
    Timestamp     = weather.utc_timestamp,
    Solar_gen     = power.DE_solar_generation_actual,
    Wind_gen      = power.DE_wind_generation_actual,
    Windspeed     = wind.windspeed_mean,
    Temperature   = temp.temp_mean,
    Radiation_dir = raddir.raddir_mean,
    Radiation_dif = raddif.raddif_mean);