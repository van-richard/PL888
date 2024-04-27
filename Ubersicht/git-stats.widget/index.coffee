# by d4Rk

command: 'git-stats.widget/gitInfo.sh'
refreshFrequency: 28800000

render: (output) -> 
  data = JSON.parse(output)
  # result = "<div class='header'><img class='logo' src='git-stats.widget/files/git-icon.svg' /><titleBold>git-stats</titleBold></div>"
  result = ""
  for item in data
    result += """
      <div>
        <div class='icon'><img class="logo" src="git-stats.widget/files/git-icon.svg"></div>
        <div class="item repo">#{item.repository}</div>
        <div class="item active">#{item.branch_active}</div>
        <div class="item branch">#{item.branch}</div>  
        <div class="item status">#{item.status}</div>
      </div>
    """
  result


  #border-radius 50px
  #background rgba(#000, 0.5)
  #webkit-backdrop-filter: blur(2px)
  #color #aaaaaa
  #box-sizing: border-box;
style: """
  right 20px
  bottom 20px
  padding 0.5em

  font-family system-ui
  font-size 0.8em
  border-radius 30px
  background rgba(#000, 0.8)
  webkit-backdrop-filter: blur(2px)
  color #aaaaaa
  box-sizing: border-box;
  div
    padding 3.5px
    margin 0 5px
    border-radius 5px
    
  div.item
    display inline-block
    padding-right 1em
    padding-top 0
    padding-bottom 0

  div.icon
    margin auto

  div.item.repo
    font-size 1.5em
    font-weight bold
    font-variant small-caps
    margin-left 3.5em
    color #b1e2e8

  div.item.active
    font-weight bold
    font-size 0.9em
    margin 0
    color #a6cce6
  
  div.item.branch
    font-size 0.9em
    color #9db6c8

  div.item.status
    display flex
    margin-left 5em
    color #6c777f

  img.logo
    position absolute
    width 35px
    height @width
    margin 0.25em 0 0 1em

  img.icon
    width 15px
    height @width
"""

update: (output) -> 
  data = JSON.parse(output)
  result = ""
  for item in data
    result += """
      <div>
        <div class='icon'><img class="logo" src="git-stats.widget/files/git-icon.svg"></div>
        <div class="item repo">#{item.repository}</div>
        <div class="item active">#{item.branch_active}</div>
        <div class="item branch">#{item.branch}</div>  
        <div class="item status">#{item.status}</div>
      </div>
    """
  result
