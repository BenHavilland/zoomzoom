# Load the application once the DOM is ready, using `jQuery.ready`:
$ ->

  # Templates
  templates = {}
  templates.vehicle = '
  <span class="vehicle_name">{{name}}</span><span class="del">x</span>
  '
  templates.vehicles = '
  <h3 class="vehicles">Vehicles</h3>
  <span class="count"></span>
  <ul class="each_vehicle"></ul>
  <input type="text" class="name" placeholder="Type new vehicle name"></input>
  <br />
  <button class="add_vehicle">Add Vehicle</button>
  <div id="dialog" title="Confirm">
    <p>
      <span class="ui-icon ui-icon-alert" style="float: left; margin: .2em .2em 0 0;"></span>
      This vehicle and all associated maintenance items will be permanently deleted and cannot be recovered. Are you sure?
    </p>
  </div>
  '
  templates.toolbar = ''
  templates.vehicle_detail = '<h2 class="vehicle_name">{{name}}</h2>'

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
    template: templates.toolbar

    render: ->
      $(@el).html Mustache.render @template
      vehiclesView = new VehiclesView
      $(@el).append vehiclesView.el
      @

  VehicleDetailView = Backbone.View.extend
    tagName: "div"
    className: "vehicle_detail"
    template: templates.vehicle_detail

    render: ->
      $(@el).html Mustache.render @template, @model.attributes
      @

  VehicleView = Backbone.View.extend
    tagName: "li"
    className: "vehicle"
    template: templates.vehicle

    events:
      'click span.del':'delVehicle'
      'click span.vehicle_name': 'showDetails'

    initialize: ->
      Vehicles.bind 'remove', @removeEl

    render: ->
      $(@el).html Mustache.render @template, @model.attributes
      @

    delVehicle: ->
      # display the "are you sure" dialog
      $("div#dialog").dialog
        resizable: false
        modal: true
        width: "50%"
        title: "Confirm Delete"
        buttons:
            "Delete": =>
                # clicked delete, delete the vehicle
                $("div#dialog").dialog( "close" )
                @model.destroy success: =>
                  # remove from the ui on successful delete
                  $(@el).remove()
            Cancel: ->
                # clicked cancel, don't delete it. just close the dialog
                $(@).dialog( "close" )
      @

    showDetails: ->
      vehicleDetailView = new VehicleDetailView model:@model
      # appending to body is a placeholder.  adding template soon
      $('body').append vehicleDetailView.render().el

  VehiclesView = Backbone.View.extend
    tagName: "div"
    className: "vehicles"
    template: templates.vehicles

    events:
      'click .add_vehicle': 'createVehicle'
      'keypress input.name'  : 'keyListner'

    initialize: ->
      # make things happen when the collection updates
      Vehicles.bind 'add', @addOne, @
      Vehicles.bind 'all', @updateCount, @
      Vehicles.bind 'reset', @addAll, @
      Vehicles.bind 'remove', @removeEl, @
      # load in the vehicles
      Vehicles.fetch()

    render: ->
      $(@el).html Mustache.render @template
      @

    updateCount: ->
      @$("span.count").html("("+Vehicles.length+")")

    addOne: (vehicle) ->
      # create and display the passed vehicle
      vehicleView = new VehicleView model:vehicle
      @$("ul.each_vehicle").append vehicleView.render().el
      @

    addAll: ->
      # cycle through each vehicle and call addOne
      @render()
      Vehicles.each(@addOne,@)
      @

    createVehicle: ->
      @input_vehicle_name = @$('input.name')
      # if there is text in the vehicle name field create it
      if !@input_vehicle_name.val()
        return
      Vehicles.create({name: @input_vehicle_name.val()})
      # clear the text to prepare for next input
      @input_vehicle_name.val('')
      @

    keyListner: (key) ->
      # let the user press -return- key unstead of clicking Add
      if key.keyCode is 13
        @createVehicle()
      @

  # App Loader View
  MainView = Backbone.View.extend
    el: $("body")

    initialize: ->
      toolBarView = new ToolBarView
      $(@el).append toolBarView.render().el

    render: ->
      @

  # Create the app
  mainView = new MainView
  mainView.render()
