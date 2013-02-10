# Load the application once the DOM is ready, using `jQuery.ready`:
$ ->

  # Templates=
  templates = {}
  templates.base =
  '<div id="content"></div>'
  templates.ben =
  '
  <a class="fork-me" href="https://github.com/clickyspinny">
    <img style="position: absolute; top: 0; left: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_left_red_aa0000.png" alt="Fork me on GitHub">
  </a>
  <span class="floating-head">
    <img src="static/img/floating_head_ben_crop_nohand.png" class="floating-head" />
    <img src="static/img/floating_head_ben_crop.png" class="floating-head-hand" />
  </span>
  '

  templates.projects =
  '<h2>Projects</h2>
  <li>
    Fog Fudge: Mezzanine, Cartridge, venv, heroku deploy<br />
    <a href="http://fogfudge.heroku.com">fogfudge.com</a><br />
    <a href="https://github.com/clickyspinny/fogfudge">github.com/clickyspinny/fogfudge</a>
  </li>
  <li>
    Zoom Zoom: Backbone.js + Coffeescript app.<br />
    <a href="http://clickyspinny.com/zoomzoom/">clickyspinny.com/zoomzoom/</a><br />
    <a href="https://github.com/clickyspinny/zoomzoom">github.com/clickyspinny/zoomzoom</a>
  </li>
  <li>
    clickyspinny: This site silly. Backbone.js + Coffeescript app, venv, heroku deploy<br />
    <a href="http://clickyspinny.com">clickyspinny.com</a><br />
    <a href="https://github.com/clickyspinny/clickyspinny.com">github.com/clickyspinny/clickyspinny.com</a>
  </li>
  '

  ### Views ###

  # App Loader View
  MainView = Backbone.View.extend
    el: $("body")
    template: templates.base

    initialize: ->
      @benView = new BenView
      @projectsView = new ProjectsView

    render: ->
      $(@el).html @template
      @

    addContent: ->
      $("div#content", @el).append @benView.render().el
      $("div#content", @el).append @projectsView.render().el
      @

  BenView = Backbone.View.extend
    tagName: 'div'
    className: 'face'
    template: templates.ben

    events:
      'hover': 'swapBens'
      'click': 'toggleLink'

    render: ->
      $(@el).html @template
      @

    swapBens: ->
      $('img.floating-head',@el).toggle()
      $('img.floating-head-hand',@el).toggle()
      @swapLog()
      @

    toggleLink: ->
      $('a.fork-me',@el).toggle()
      @

    swapLog: ->
      # We'll add a log message in later, prob as a speech bubble close to my head
      #console.log "Yeah, I got that trendy Git-Hub thing up there."
      @

  ProjectsView = Backbone.View.extend
    tagName: 'div'
    className: 'projects'
    template: templates.projects

    render: ->
      $(@el).html @template
      @


  # Create the app
  mainView = new MainView
  mainView.render().addContent()