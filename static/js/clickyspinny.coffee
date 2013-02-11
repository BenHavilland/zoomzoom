# Load the application once the DOM is ready, using `jQuery.ready`:
$ ->

  # Templates=
  templates = {}
  templates.base =
  '<div id="content"><div id="main-container"></div><div id="menu"></div></div>'
  templates.ben =
  '
  <a class="fork-me" href="https://github.com/clickyspinny">
    <img style="position: fixed; top: 0; right: 0; border: 0; z-index: 1030;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png" alt="Fork me on GitHub">
  </a>
  <!--
  <span class="floating-head">
    <img src="static/img/floating_head_ben_crop_nohand.png" class="floating-head" />
    <img src="static/img/floating_head_ben_crop.png" class="floating-head-hand" />
  </span>
  -->
  '

  templates.code_projects =
  '<h2>PROJECTS</h2>
  <ul>
  <li>
    FOG FUDGE&trade;: Mezzanine, Cartridge, venv, heroku deploy<br />
    <a href="http://fogfudge.heroku.com">fogfudge.com</a><br />
    <a href="https://github.com/clickyspinny/fogfudge">github.com/clickyspinny/fogfudge</a>
  </li>
  <li>
    ZOOM ZOOM: Backbone.js + Coffeescript<br />
    <a href="http://clickyspinny.com/zoomzoom/">clickyspinny.com/zoomzoom/</a><br />
    <a href="https://github.com/clickyspinny/zoomzoom">github.com/clickyspinny/zoomzoom</a>
  </li>
  <li>
    CLICKYSPINNY: This site silly. Backbone.js, Coffeescript, Twitter Bootstrap, venv, heroku deploy<br />
    <a href="http://clickyspinny.com">clickyspinny.com</a><br />
    <a href="https://github.com/clickyspinny/clickyspinny">github.com/clickyspinny/clickyspinny</a>
  </li>
  </ul>
  '

  templates.fogfudge =
  '<h2>FOG FUDGE&trade;</h2>
  <ul>
  <li>
    Mezzanine, Cartridge, venv, heroku deploy<br />
    <a href="http://www.fogfudge.com">fogfudge.com</a><br />
    <a href="https://github.com/clickyspinny/fogfudge">github.com/clickyspinny/fogfudge</a>
  </li>
  </ul>
  '

  templates.zoomzoom =
  '<h2>ZOOM ZOOM</h2>
  <ul>
  <li>
    Backbone.js + Coffeescript<br />
    <a href="http://clickyspinny.com/zoomzoom/">clickyspinny.com/zoomzoom/</a><br />
    <a href="https://github.com/clickyspinny/zoomzoom">github.com/clickyspinny/zoomzoom</a>
  </li>
  </ul>
  '

  templates.wifishelter =
  '<h2>WIFI SHELTER</h2>
  <ul>
    <a href="http://www.wifishelter.com">wifishelter.com</a>
  </li>
  </ul>
  '

  templates.clickyspinny =
  '<h2>CLICKYSPINNY</h2>
  <ul>
  <li>
    <p>
    This site silly. Backbone.js, Coffeescript, Twitter Bootstrap, venv, heroku deploy<br />
    <a href="http://clickyspinny.com">clickyspinny.com</a><br />
    <a href="https://github.com/clickyspinny/clickyspinny">github.com/clickyspinny/clickyspinny</a>
    </p>
  </li>
  </ul>
  '

  templates.main_menu =
  '
  <ul>
  <a href="#fogfudge">
  <li>
    FOG FUDGE&trade;
  </li>
  </a>
  <a href="#zoomzoom">
  <li>
    ZOOM ZOOM
  </li>
  <!--
  <a href="#wifishelter">
  <li>
    WIFI SHELTER
  </li>
  </a> -->
  <a href="#clickyspinny">
  <li>
    CLICKYSPINNY
  </li>
  </a>
  </ul>
  '

  ### Router ###
  ClickySpinner = Backbone.Router.extend
  
    initialize: (options) ->
      # Create the app
      @mainView = new MainView
      @mainView.render().addContent()
      @codeProjectsView = new CodeProjectsView
      @fogFudgeView = new FogFudgeView
      @zoomZoomView = new ZoomZoomView
      @clickySpinnyView = new ClickySpinnyView
      @wifiShelterView = new WifiShelterView
    
    routes:
      "code": "code"
      "fogfudge":"fogfudge"
      "zoomzoom": "zoomzoom"
      "clickyspinny": "clickyspinny"
      "wifishelter":"wifishelter"
      "": "code"
      "*actions":"defaultRoute"

    code: ->
      $("div#main-container").html @codeProjectsView.render().el
      @

    fogfudge: ->
      $("div#main-container").html @fogFudgeView.render().el
      @

    zoomzoom: ->
      $("div#main-container").html @zoomZoomView.render().el
      @

    clickyspinny: ->
      $("div#main-container").html @clickySpinnyView.render().el
      @

    wifishelter: ->
      $("div#main-container").html @wifiShelterView.render().el
      @

    defaultRoute: (clicked) ->
      console.log @
      $("div#main-container").html ""
      # envoke route here
      #$("div#main-container").html "<div class='projects'><h2>"+clicked.toElement.innerText+"</h2></div>"
      console.log clicked
      @
  
  ### Views ###

  # App Loader View
  MainView = Backbone.View.extend
    el: $("div.hero-unit")
    template: templates.base

    initialize: ->
      @benView = new BenView
      #@mainMenuView = new MainMenuView

    render: ->
      $(@el).html @template
      @

    addContent: ->
      $("div#ben").html @benView.render().el
      #$("div#main-container", @el).html @codeProjectsView.render().el
      #$("div#menu", @el).html @mainMenuView.render().el
      @

  BenView = Backbone.View.extend
    tagName: 'div'
    className: 'ben'
    template: templates.ben

    events:
      'hover': 'swapBens'
      #'click': 'toggleLink'

    render: ->
      $(@el).html @template
      @

    swapBens: ->
      $('img.floating-head',@el).toggle()
      $('img.floating-head-hand',@el).toggle()
      @swapLog()
      @

    #toggleLink: ->
    #  $('a.fork-me',@el).toggle()
    #  @

    swapLog: ->
      # We'll add a log message in later, prob as a speech bubble close to my head
      #console.log "Yeah, I got that trendy Git-Hub thing up there."
      @

  CodeProjectsView = Backbone.View.extend
    tagName: 'div'
    className: 'projects'
    template: templates.code_projects

    render: ->
      $(@el).html @template
      @

  FogFudgeView = Backbone.View.extend
    tagName: 'div'
    className: 'projects'
    template: templates.fogfudge

    render: ->
      $(@el).html @template
      @

  ClickySpinnyView = Backbone.View.extend
    tagName: 'div'
    className: 'projects'
    template: templates.clickyspinny

    render: ->
      $(@el).html @template
      @

  ZoomZoomView = Backbone.View.extend
    tagName: 'div'
    className: 'projects'
    template: templates.zoomzoom

    render: ->
      $(@el).html @template
      @

  WifiShelterView = Backbone.View.extend
    tagName: 'div'
    className: 'projects'
    template: templates.wifishelter

    render: ->
      $(@el).html @template
      @

  MainMenuView = Backbone.View.extend
    tagName: 'div'
    className: 'main-menu'
    template: templates.main_menu

    render: ->
      $(@el).html @template
      @

  @clickySpinner = new ClickySpinner

  #Start Backbone history a necessary step for bookmarkable URL's
  Backbone.history.start()