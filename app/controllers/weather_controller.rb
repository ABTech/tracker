require 'net/http'

class WeatherController < ApplicationController
    def index
      @title = "Weather"
      authorize! :index, WeatherController
      @nws_weather_link = "https://forecast.weather.gov/MapClick.php?w0=t&w1=td&w2=hi&w3=sfcwind&w4=sky&w5=pop&w6=rh&w7=rain&w8=thunder&w9=fog&w12=lal&w19=vsby&w20=pt&AheadHour=0&Submit=Submit&&FcstType=graphical&textField1=40.439&textField2=-79.9584&site=all"
      nws_weather_img = "https://forecast.weather.gov/meteograms/Plotter.php?lat=40.439&lon=-79.9584&wfo=PBZ&zcode=PAZ021&gset=20&gdiff=10&unit=0&tinfo=EY5&ahour=0&pcmd=11101111110000101000001000000000000000000000000000000100000&lg=en&indu=1!1!1!&dd=&bw=&hrspan=48&pqpfhr=6&psnwhr=6"
      nws_time = Time.now
      @nws_time_string = nws_time.to_s
      @nws_time_float_string = nws_time.to_f.to_s
      nws_weather_img_no_cache = nws_weather_img + "&no_cache_str=" + @nws_time_float_string
      image_res = Net::HTTP.get_response(URI(nws_weather_img_no_cache))
      if image_res.code == '200'
        @nws_weather_image_b64 = 'data:' + image_res['Content-Type'] + ';base64,' + Base64.strict_encode64(image_res.body)
      else
        @nws_weather_image_error = 'Error fetching forecast image: ' + image_res.message
      end
    end
end
