# Load the application once the DOM is ready, using `jQuery.ready`:
$ ->

  # Templates
  templates = {}
  templates.base = '
  <div class="header">
      <h1>ZoomZoom</h1>
      <div class="subtitle">Maintenance logger for your vehicles</div>
      <div id="dialog" title="Confirm">
        <p>
          <span class="ui-icon ui-icon-alert" style="float: left; margin: .2em .2em 0 0;"></span>
          <span class="alert_content"></span>
        </p>
      </div>
  </div>
  '
  templates.center = '
  '
  templates.right = '
  '
  templates.vehicle = '
  <span class="menu">{{name}}</span><span class="del">x</span>
  '
  templates.vehicles = '
  <div class="title">
    <h3 class="vehicles">Vehicles</h3>
    <span class="count"></span>
    <span class="show_hide">...</span>
  </div>
  <div class="view_container">
    <ul class="each_vehicle"></ul>
    <input type="text" class="name" placeholder="Type new vehicle name" />
    <button class="add_vehicle">Add Vehicle</button>
  </div>
  '
  templates.toolbar = ''
  templates.vehicle_log = '
  <div class="title">
    <h3 class="vehicle_name">{{name}}</h3>
    <span class="show_hide">...</span>
  </div>
  <div class="view_container">
    <ul class="log"></ul>
  </div>
  '
  templates.vehicle_log_item = '
  <span class="menu">
    <span>{{title}}</span>
    <span class="cost">{{cost}}</span>
  </span>
  <span class="del">x</span>
  '
  templates.vehicle_add_log = '
  <div class="title">
    <h3 class="add_log_title">Add Log Entry</h3>
    <span class="show_hide">...</span>
  </div>
  <div class="view_container">
    <input type="text" id="miles" class="log miles" placeholder="Mileage at time of work" />
    <input type="text" id="title" class="log title" placeholder="Title" />
    <input type="text" id="description" class="log desc" placeholder="Description" />
    <input type="text" id="cost" class="log cost" placeholder="Cost" />
    <button class="add_log">Add Log Entry</button>
  </div>
  '

  # Models
  # coming soon...
  class Vehicle extends Backbone.Model

    # make all vehicles awesome
    defaults: ->
      isAwesome: "yes"

    initialize: ->
      # tell the browser console that we're taking the vehicle model for a spin
      console.log "vehicle initialized"

  class LogItem extends Backbone.Model
    # make all vehicles awesome
    defaults: ->
      added: new Date()

    # tell the browser console that we're taking the vehicle model for a spin
    initialize: ->
      console.log "log item initialized"

  # Collections
  class VehicleList extends Backbone.Collection

    # reference vehicle model
    model: Vehicle

    # save the set under the "vehicles" namespace
    localStorage: new Store("vehicles-backbone")

  class LogItems extends Backbone.Collection
    # reference vehicle model
    model: LogItem

    # save the set under the "vehicles" namespace
    localStorage: new Store("vehicle-logs-backbone")

  # create our global collection of Vehicles.
  Vehicles = new VehicleList
  # create our global of Log Item
  LogItems = new LogItems
  LogItems.fetch()

  # Views
  ToolBarView = Backbone.View.extend
    tagName: "div"
    className: "toolbar panel"
    template: templates.toolbar

    render: ->
      $(@el).html Mustache.render @template
      vehiclesView = new VehiclesView
      $(@el).append vehiclesView.el
      @

  LogView = Backbone.View.extend
    tagName: "div"
    className: "vehicle_log"
    template: templates.vehicle_log

    initialize: ->
      LogItems.where("vehicleId":@model.id)
      LogItems.bind 'add', @addOne, @
      LogItems.bind 'reset', @addAll, @
      @render()
    
    events:
      'click div.title' : 'toggleVisible'

    render: ->
      $(@el).html Mustache.render @template, @model.attributes
      @

    addOne: (logItem) ->
      # create and display the passed log item
      logItemView = new LogItemView model:logItem
      @$("ul.log").append logItemView.render().el
      @

    addAll: ->
      _.each(LogItems.where("vehicleId":@model.id),@addOne,@)
      @

    toggleVisible: ->
      @$('.view_container', @el).toggle()
      @$('.show_hide', @el).toggleClass('show_hide_show')
      @$('div.title', @el).toggleClass('add_margin')
      @

  LogItemView = Backbone.View.extend
    tagName: "li"
    className: "menu"
    template: templates.vehicle_log_item

    events:
      'click span.del':'delLogItem'

    render: ->
      $(@el).html Mustache.render @template, @model.attributes
      @

    delLogItem: ->
      # display the "are you sure" dialog
      $("span.alert_content").html "This maintenance item will be permanently deleted and cannot be recovered. Are you sure?"
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

  VehicleAddLogView = Backbone.View.extend
    tagName: "div"
    className: "vehicle_add_log"
    template: templates.vehicle_add_log

    events:
      'click button.add_log': 'createLogItem'
      'keypress input'  : 'keyListener'
      'click div.title' : 'toggleVisible'

    render: ->
      $(@el).html Mustache.render @template, @model.attributes
      @

    createLogItem: ->
      # if there is text in the log title field we'll create it
      if !@$('input.title').val()
        return
      form_vals = {}
      form_vals.vehicleId = @model.id
      _.each @$('input'), (field) ->
        form_vals[$(field).attr('id')] = $(field).val()
      console.log form_vals
      LogItems.create(form_vals)
      # clear the text in all fields to prepare for next input
      @$('input').val('')
      @

    keyListener: (key) ->
      # let the user press -return- key unstead of clicking Add
      if key.keyCode is 13
        @createLogItem()
      @

    toggleVisible: ->
      @$('.view_container', @el).toggle()
      @$('.show_hide', @el).toggleClass('show_hide_show')
      @$('div.title', @el).toggleClass('add_margin')
      @

  VehicleView = Backbone.View.extend
    tagName: "li"
    className: "menu"
    template: templates.vehicle

    events:
      'click span.del':'delVehicle'
      'click span.menu': 'showDetails'

    render: ->
      $(@el).html Mustache.render @template, @model.attributes
      @

    delVehicle: ->
      # display the "are you sure" dialog
      $("span.alert_content").html "This vehicle and all associated maintenance items will be permanently deleted and cannot be recovered. Are you sure?"
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

      # test for phonegap api
      navigator.notification.alert(
        'You are the winner!',  #message
        @alertDismissed,         #callback
        'Game Over',            #title
        'Done'                  #buttonName
      )
      navigator.notification.vibrate 2000
      @

    alertDismissed: ->
      @

    showDetails: ->
      vehicleLogView = new LogView model:@model
      $('div.center_container').html vehicleLogView.addAll().el
      vehicleAddLogView = new VehicleAddLogView model:@model
      $('div.right_container').html vehicleAddLogView.render().el

  VehiclesView = Backbone.View.extend
    tagName: "div"
    className: "vehicles"
    template: templates.vehicles

    events:
      'click .add_vehicle' : 'createVehicle'
      'keypress input.name' : 'keyListener'
      'click div.title' : 'toggleVisible'

    initialize: ->
      # make things happen when the collection updates
      Vehicles.bind 'add', @addOne, @
      Vehicles.bind 'all', @updateCount, @
      Vehicles.bind 'reset', @addAll, @
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

    keyListener: (key) ->
      # let the user press -return- key unstead of clicking Add
      if key.keyCode is 13
        @createVehicle()
      @

    toggleVisible: ->
      @$('.view_container', @el).toggle()
      @$('.show_hide', @el).toggleClass('show_hide_show')
      @$('div.title', @el).toggleClass('add_margin')
      @

  CenterContainerView = Backbone.View.extend
    tagName: "div"
    className: "center_container panel"
    template: templates.center

    render: ->
      $(@el).html Mustache.render @template
      @

  RightContainerView = Backbone.View.extend
    tagName: "div"
    className: "right_container panel"
    template: templates.right

    render: ->
      $(@el).html Mustache.render @template
      @

  # App Loader View
  MainView = Backbone.View.extend
    el: $("body")
    template: templates.base

    initialize: ->
      @toolBarView = new ToolBarView
      @centerContainerView = new CenterContainerView
      @rightContainerView = new RightContainerView

    render: ->
      $(@el).html Mustache.render @template
      $(@el).append @toolBarView.render().el
      $(@el).append @centerContainerView.render().el
      $(@el).append @rightContainerView.render().el
      @

  # Create the app
  mainView = new MainView
  mainView.render()
