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

    events:
      'click .add_vehicle': 'createVehicle'

    # will change to real template shortly
    template: "<h3 class='vehicles'>Vehicles</h3> <span class='count'></span>
    <ul class='vehicles'></ul>
    <input type='text' class='name' placeholder='Type new vehicle name'></input>
    <br />
    <button class='add_vehicle'>Add Vehicle</button>
    "

    initialize: ->
      $('body').append @render().el
      vehiclesView = new VehiclesView
      $(@el).append vehiclesView.render().el
      @input_vehicle_name = @$('input.name')
      @

    render: ->
      $(@el).html @template
      @

    createVehicle: ->
      if !@input_vehicle_name.val()
        return
      Vehicles.create({name: @input_vehicle_name.val()})
      @input_vehicle_name.val('')
      @

  VehicleView = Backbone.View.extend
    tagName: "li"
    className: "vehicle"

    # will change to real template shortly
    template: "{{vehicle.titlel}}"

    render: ->
      $(@el).html @model.get 'name' # this will change once we activate the templates
      console.log @model
      @

  VehiclesView = Backbone.View.extend
    el: $("div.toolbar")

    initialize: ->
      Vehicles.bind 'add', @addOne, @
      Vehicles.bind 'all', @render, @
      Vehicles.bind 'reset', @addAll, @
      Vehicles.fetch()

    render: ->
      # update the vehicle count
      $("span.count").html("("+Vehicles.length+")")
      @

    addOne: (vehicle) ->
      vehicleView = new VehicleView model:vehicle
      $("ul.vehicles").append vehicleView.render().el
      @

    addAll: ->
      Vehicles.each(@addOne)
      @

  # App Loader View
  # coming soon...

  # Create the app
  ToolBar = new ToolBarView
