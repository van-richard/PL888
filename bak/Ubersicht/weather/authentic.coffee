# Authentic Weather for Übersicht
# reduxd, 2015

# ------------------------------ CONFIG ------------------------------

# forecast.io api key
apiKey: 'ac8d16dbea9a0ff467502cf6c61ba89c'

# units; 'c' for celsius, 'f' for fahrenheit
unit: 'imperial'

# icon set; 'black', 'white', and 'blue' supported
color: 'white'

# weather icon above text; true or false
showIcon: true

# temperature above text; true or false
showTemp: true

# refresh every '(60 * 1000)  * x' minutes
refreshFrequency: (60 * 1000) * 20

# fallback location in case geolocation fails
coords: {latitude: '35.467560', longitude: '-97.486702'}

# ---------------------------- END CONFIG ----------------------------

exclude: "minutely,hourly,alerts,flags"

command: "echo {}"

makeCommand: (apiKey, lat, lon) ->
  "curl -sS 'https://api.openweathermap.org/data/3.0/onecall?lat=#{lat}&lon=#{lon}&exclude=#{ @part }&units=#{ @unit }&appid=#{apiKey}'"

render: (o) -> """
	<article id="content">

		<!-- snippet -->
		<div id="snippet">
		</div>

		<!--phrase text box -->
		<h1>
		</h1>

		<!-- subline text box -->
		<h2>
		</h2>
	</article>
"""

afterRender: (domEl) ->
	
	updateScreen = (coords) =>
		@command   = @makeCommand(@apiKey, @coords.latitude, @coords.longitude)
		@refresh()

	updateScreen(@coords)


update: (o, dom) ->
	data = JSON.parse(o)
	return unless data.current?
	# console.log('current data',data.current)

	currentTemperature = data.current.temp
	# t_like = data.current.feels_like
	currentWindSpeed = data.current.wind_speed

	currentData = data.current.weather[0]
	currentDescription = currentData.description
	# Icon code : https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2
	currentIcon = currentData.icon

	# snippet control
	snippetContent = []

	if @showIcon
		snippetContent.push "<img src='weather/icon/#{ @color }/#{ currentIcon }.png'></img>"

	if @showTemp
		if @unit == 'f'
			snippetContent.push " #{ Math.round(currentTemperature) } °F"
		else
			snippetContent.push " #{ Math.round(currentTemperature) }°"
			# snippetContent.push " #{ Math.round(t_like) }°"
	
	# snippetContent.push " #{ Math.round(currentWindSpeed) } mph"
	$(dom).find('#snippet').html snippetContent.join ''

	# get relevant phrase
	@parseStatus(currentIcon, currentTemperature, dom)

# phrases dump from android app
parseStatus: (summary, temperature, dom) ->
	c = []
	s = []
	$.getJSON 'weather/phrases.json', (data) ->
		$.each data.phrases, (key, val) ->
			# condition based
			if val.condition == summary
				if val.min < temperature
					if val.max > temperature
						c.push val
						s.push key

					if typeof val.max == 'undefined'
						c.push val
						s.push key

				if typeof val.min == 'undefined'
					if val.max > temperature
						c.push val
						s.push key

					if typeof val.max == 'undefined'
						c.push val
						s.push key

			# temp based
			if typeof val.condition == 'undefined'
				if val.min < temperature
					if val.max > temperature
						c.push val
						s.push key

					if typeof val.max == 'undefined'
						c.push val
						s.push key

				if typeof val.min == 'undefined'
					if val.max > temperature
						c.push val
						s.push key

					if typeof val.max == 'undefined'
						c.push val
						s.push key

		r = c[Math.floor(Math.random()*c.length)]
		title = r.title
		highlight = r.highlight[0]
		color = r.color
		sub = r.subline
		nextTest = s[Math.floor(Math.random()*c.length)]

		text = title.replace(/\|/g, " ")

		c1 = new RegExp(highlight, "g")
		c2 = "<i style=\"color:" + color + "\">" + highlight + "</i>"

		text2 = text.replace(c1, c2)
		text3 = text2.replace(/>\?/g, ">")

		$(dom).find('h1').html text3
		$(dom).find('h2').html sub

# adapted from authenticweather.com
style: """
	bottom 0px
	padding 10px
	width 20%
	font-family system-ui
	font-smooth always
	color #ffffff

	#snippet
		font-size 2.3em
		font-weight 500

		img
			max-width 50px

	h1
		font-size 2em
		font-weight 300
		letter-spacing -0.04em
		margin 0 0 0 0

	h2
		font-weight 150
		font-size 0.75em

	i
		font-style normal
"""
