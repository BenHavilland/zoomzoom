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
  <a href="https://github.com/clickyspinny">
    <img src="static/img/floating_head_ben_crop_nohand.png" class="floating-head" />
    <img src="static/img/floating_head_ben_crop.png" class="floating-head-hand" />
  </a>
  '

  # Views
  BenView = Backbone.View.extend
    tagName: 'div'
    className: 'face'
    template: templates.ben

    events:
      'hover': 'swapHeads'

    render: ->
      $(@el).html @template
      @

    swapHeads: ->
      $('img.floating-head',@el).toggle()
      $('img.floating-head-hand',@el).toggle()
      $('a.fork-me',@el).toggle()
      @swapLog()
      @

    swapLog: ->
      # We'll add a log message in later, prob as a speech bubble close to my head
      #console.log "Yeah, I got that trendy Git-Hub thing up there."
      @

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

  # Create the app
  mainView = new MainView
  mainView.render().addContent()