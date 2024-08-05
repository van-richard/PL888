# CLOCK
showTime = ->
  time = new Date
  hour = time.getHours()
  min = time.getMinutes()
  sec = time.getSeconds()
  # am_pm = 'AM'
  # if hour > 12
  #   hour -= 12
  #   am_pm = 'PM'
  # if hour == 0
  #   hr = 12
  #   am_pm = 'AM'
  hour = if hour < 10 then '0' + hour else hour
  min = if min < 10 then '0' + min else min
  sec = if sec < 10 then '0' + sec else sec
  currentTime = '<span class="hour-min">' + hour + ':' + min + '</span>' #+ '<div class="clock-inf"><span class="sec">' + sec + '</span></div>'
  document.getElementById('clock').innerHTML = currentTime
  return
setInterval showTime, 1000
  

refreshFrequency: 3600000

style: """
  top: 10px
  right: 0
  color: #fff
  width: 100%
  opacity: 0.9
  
  #clock
    font-weight: 100 
    font-family: system-ui
    display: flex
    align-items: center
    gap: 0
    right: 0
    position: relative

  .hour-min
    font-size: 100px
    text-align: center
    margin: auto
    
  .clock-inf
    display: grid
    font-size: 3.5em
    line-height: 1

  .grey
    color: #ccc
    opacity: 0.5
"""

render: -> """
  <div id="clock"></div>
"""
