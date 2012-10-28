# Load the application once the DOM is ready, using `jQuery.ready`:
$ ->

  # fade it all in
  $('body').fadeIn();

  # Models
  # coming soon...
  class Vehicle extends Backbone.Model

    # make all vehicles awesome
    defaults: ->
      isAwesome: "yes"

    # tell the browser console that we're taking the vehicle model for a spin
    initialize: ->
      console.log "vehicle initialized"

  # Collections
  class VehicleList extends Backbone.Collection

    # reference vehicle model
    model: Vehicle

    # save the set under the "vehicles" namespace
    localStorage: new Store("vehicles-backbone")

  # create our global collection of Vehicles.
  Vehicles = new VehicleList;

  # Views
  ToolBarView = Backbone.View.extend
    tagName: "div"
    className: "toolbar"

    # will change to real template shortly
    template: "<p>This is just a local template doc  that will be \
    changed in the near future.<p/> \
    <p>Once we define out models we will add list items here like below.</p>
    "

    initialize: ->
      $('body').append @render().el
      vehiclesView = new VehiclesView
      $(@el).append vehiclesView.render().el

    render: ->
      $(@el).html @template
      @

  VehicleView = Backbone.View.extend
    tagName: "li"
    className: "vehicle"

    # will change to real template shortly
    template: "Y{{year}} M{{make}} M{{model}}"

    render: ->
      $(@el).html @template
      @

  VehiclesView = Backbone.View.extend
    # This will become a ul tag once we hook up the model control buttons
    tagName: "div"
    className: "vehicles"

    # Here as placeholder content until we add some vehicles
    template: "<h3>Cars</h3>
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
      </ul>"

    initialize: ->
      Vehicles.bind 'reset', @addAll, @
      Vehicles.fetch()

    render: ->
      $(@el).html @template
      @

    addOne: (vehicle) ->
      console.log 'here is one vehicle'
      vehicleView = new VehicleView model:vehicle
      $(@el).append(vehicleView.render().el);
      @

    addAll: ->
      console.log 'polling all'
      Vehicles.each(@addOne)
      @


  # App Loader View
  # coming soon...

  # Create the app
  ToolBar = new ToolBarView
