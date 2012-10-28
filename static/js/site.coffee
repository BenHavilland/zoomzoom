# Load the application once the DOM is ready, using `jQuery.ready`:
$ ->

  # fade it all in
  $('body').fadeIn();

  # Models
  # coming soon...

  # Collections
  # coming soon...

  # Views
  ToolBarView = Backbone.View.extend
    tagName: "div"
    className: "toolbar"
    template: "<p>This is just a local template doc  that will be \
    changed in the near future.<p/> \
    <p>Once we define out models we will add list items here like below.</p>
    <h3>Cars</h3>
    <ul>
      <li>2001 Volvo V70 T5</li>
      <li>1991 BMW 325ic</li>
      <li>1976 Ford F350</li>
    </ul>
    <h3>Motorcycles</h3>
    <ul>
      <li>1980 Honda CB750</li>
      <li>1980 Honda CM400T</li>
      <li>1982 Honda CM250C</li>
    </ul>
    "

    initialize: ->
      $('body').append @render().el

    render: ->
      $(@el).html @template
      @

  # App Loader View
  # coming soon...

  # Create the app
  ToolBar = new ToolBarView
