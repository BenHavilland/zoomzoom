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
  <li>Zoom Zoom: Backbone.js + Coffeescript app.</li>
  <li>another</li>
  <li>another</li>
  <li>another</li>
  '

  ### Views ###

  # App Loader View
  MainView = Backbone.View.extend
    el: $("body")
    template: templates.base

    initialize: ->
      @benView = new BenView

    render: ->
      $(@el).html @template
      @

    addContent: ->
      $("div#content", @el).append @benView.render().el
      @

  BenView = Backbone.View.extend
    tagName: 'span'
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

  # Create the app
  mainView = new MainView
  mainView.render().addContent()