import shutil

import requests

baseUrl = 'http://openweathermap.org/img/wn/'
imgDim = "@2x"
fileExt = '.png'
imageIDs = [
    "01d", "02d", "03d", "04d", "09d", "10d", "11d", "13d", "50d",
    "01n", "02n", "03n", "04n", "09n", "10n", "11n", "13n", "50n"
]
for id in imageIDs :
    imageFileName = id + imgDim + fileExt
    url = baseUrl + imageFileName
    response = requests.get(url, stream=True)
    with open(imageFileName, 'wb') as out_file:
        shutil.copyfileobj(response.raw, out_file)
        del response