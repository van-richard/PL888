# by d4Rk

command: 'git-stats/gitInfo.sh'

# refresh every '(60 * 1000)  * x' minutes
refreshFrequency: (60 * 1000) * 15

render: (output) -> 
  data = JSON.parse(output)
  result = ""
  for item in data
    result += """
      <div>
        <div>#{item.repository}</div>
        <div class="item" style="color:#{item.color}"><img class='icon' src='git-stats/icons/#{item.icon}.svg' />#{item.n_commits}</div>
        <div class="item"><img class='icon' src='git-stats/icons/branch.svg' />#{item.branch}</div>
      </div>
    """
  result
        # <div class="item"><img class='icon' src='git-stats/icons/branch.svg' />#{item.modified}</div>
        # <div class="item"><img class='icon' src='git-stats/icons/branch.svg' />#{item.untracked}</div>
# <div class='icon'><img class="logo" src="git-stats/files/git-icon.svg"></div>

#border-radius 50px
#background rgba(#000, 0.5)
#webkit-backdrop-filter: blur(2px)
#color #aaaaaa
#box-sizing: border-box;

style: """
  right 0px
  bottom 0px
  padding 10px

  font-family system-ui
  font-size 1em
  color #ffffff

  div
    padding 3.5px
    margin 0 5px
    
  div.item
    display inline-block
    font-size 0.9em

  img.logo
    position absolute
    width 30px
    height @width
    margin 0.25em 0 0 1em

  img.icon
    width 15px
    height @width
    padding-right 4px
"""

# update: (output) -> 
#   data = JSON.parse(output)
#   result = ""
#   for item in data
#     result += """
#       <div>
#         <div class='icon'><img class="logo" src="git-stats/git-icon.svg"></div>
#         <div class="item repo">#{item.repository}</div>
#         <div class="item branch">#{item.branch}</div>  
#         <div class="item status">#{item.status}</div>
#         <div class="item status">#{item.n_commits}</div>
#       </div>
#     """
#   result
