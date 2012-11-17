# Load the application once the DOM is ready, using `jQuery.ready`:
$ ->

  # Templates
  templates = {}
  templates.base = '
  <div class="header">
    <h1>ZoomZoom</h1>
    <div class="subtitle">Maintenance logger for your vehicles</div>
  </div>
  <div id="head_nav"></div>
  <div id="content"></div>
  <div id="dialog" title="Confirm">
    <p>
      <span class="ui-icon ui-icon-alert" style="float: left; margin: .2em .2em 0 0;"></span>
      <span class="alert_content"></span>
    </p>
  </div>
  '
  templates.breadcrumb = '{{title}}'
  templates.breadcrumbs = ''
  templates.vehicle = '<span class="menu">{{name}}</span>'
  templates.vehicles = '
  <div class="title">
    <h3 class="vehicles">Vehicles</h3>
    <span class="count"></span>
  </div>
  <div class="view_container">
    <ul class="each_vehicle"></ul>
    <input type="text" class="name" placeholder="Type new vehicle name" />
    <button class="add_vehicle">Add Vehicle</button>
  </div>
  '
  templates.vehicle_log = '
  <div class="title">
    <h3 class="vehicle_name">{{name}}</h3>
  </div>
  <div class="view_container">
    <ul class="log"></ul>
  </div>
  <div>
    <button class="add_log_item">Add Log Item</button>
    <button class="edit">Edit Vehicle</button>
    <button class="delete">Delete Vehicle</button>
  </div>
  '
  templates.vehicle_log_item = '
  <span class="menu">
    <span class="title">{{title}}</span>
  </span>
  '
  templates.vehicle_log_item_full = '
  <div class="view_container">
    <h3 class="title">{{title}}</h3>
    <ul>
      <li>
        <span class="label">Miles:</span>
        <span class="miles">{{miles}}</span>
      </li>
      <li>
        <span class="label">Cost:</span>
        <span class="cost">{{cost}}</span>
      </li>
      <li>
        <span class="label">Description:</span>
        <span class="description">{{description}}</span>
      </li>
    </ul>
  </div>
  <div>
    <button class="edit">Edit Log Item</button>
    <button class="delete">Delete Log Item</button>
  </div>
  '
  templates.vehicle_add_log = '
  <div class="title">
    <h3 class="add_log_title">Add Log Entry</h3>
  </div>
  <div class="view_container">
    <input type="text" id="miles" class="log miles" placeholder="Mileage at time of work" />
    <input type="text" id="title" class="log title" placeholder="Title" maxlength="40"/>
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
      'click button.add_log_item': 'showAddLog'
      'click button.delete':'delVehicle'

    render: ->
      $(@el).html Mustache.render @template, @model.attributes
      Breadcrumbs.addOne(@model.get "name")
      @

    addOne: (logItem) ->
      # create and display the passed log item
      logItemView = new LogItemView model:logItem
      @$("ul.log").append logItemView.render().el
      @

    addAll: ->
      logItems = LogItems.where("vehicleId":@model.id)
      if logItems[0]
        _.each(logItems,@addOne,@)
      else
        @$("ul.log").html "No log items."

      @

    showAddLog: ->
      vehicleAddLogView = new VehicleAddLogView model:@model
      $('div#content').html vehicleAddLogView.render().el
      Breadcrumbs.addOne("Add Log Item")

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

  FullLogItemView = Backbone.View.extend
    tagName: "div"
    className: "full_log"
    template: templates.vehicle_log_item_full

    events:
      'click button.delete':'delLogItem'

    render: ->
      console.log @model
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

  LogItemView = Backbone.View.extend
    tagName: "li"
    className: "menu"
    template: templates.vehicle_log_item

    events:
      'click span.menu': 'renderFull'

    render: ->
      $(@el).html Mustache.render @template, @model.attributes
      @

    renderFull: ->
      fullLogItemView = new FullLogItemView model:@model
      $('div#content').html fullLogItemView.render().el
      Breadcrumbs.addOne("#"+@model.get "title")

  VehicleAddLogView = Backbone.View.extend
    tagName: "div"
    className: "vehicle_add_log"
    template: templates.vehicle_add_log

    events:
      'click button.add_log': 'createLogItem'
      'keypress input'  : 'keyListener'

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

  VehicleView = Backbone.View.extend
    tagName: "li"
    className: "menu"
    template: templates.vehicle

    events:
      'click span.menu': 'showDetails'

    render: ->
      $(@el).html Mustache.render @template, @model.attributes
      @

    showDetails: ->
      vehicleLogView = new LogView model:@model
      $('div#content').html vehicleLogView.addAll().el

  BreadcrumbsView = Backbone.View.extend
    tagName: 'ul'
    className: 'breadcrumbs'
    template: templates.breadcrumbs

    render: ->
      $(@el).html Mustache.render @template
      console.log "crumby render"
      @

    addOne: (name) ->
      breadcrumbView = new BreadcrumbView model:name
      $(@el).append breadcrumbView.render().el
      @

  # breadcrumbs global
  Breadcrumbs = new BreadcrumbsView

  BreadcrumbView = Backbone.View.extend
    tagName: 'li'
    className: 'breadcrumb'
    template: templates.breadcrumb

    events:
      'click': 'followBreadcrumb'

    render: ->
      console.log @model
      $(@el).html Mustache.render @template ,title: @model
      @

    followBreadcrumb: ->
      name = $(@el).html()

      if name is "Add Log Item"
        return @

      @removeCrumbs()

      if name is "Vehicles"
        vehiclesView = new VehiclesView
        $("div#content").html vehiclesView.el
        return @

      vehicle = Vehicles.where("name":name)
      vehicleLogView = new LogView model:vehicle[0]
      $('div#content').html vehicleLogView.addAll().el
      @

    removeCrumbs: ->
      $(@el).nextAll().remove()
      $(@el).remove()
      @

  VehiclesView = Backbone.View.extend
    tagName: "div"
    className: "vehicles"
    template: templates.vehicles

    events:
      'click .add_vehicle' : 'createVehicle'
      'keypress input.name' : 'keyListener'

    initialize: ->
      # make things happen when the collection updates
      Vehicles.bind 'add', @addOne, @
      Vehicles.bind 'all', @updateCount, @
      Vehicles.bind 'reset', @addAll, @
      # load in the vehicles
      Vehicles.fetch()

    render: ->
      $(@el).html Mustache.render @template
      Breadcrumbs.render().addOne("Vehicles")
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

  # App Loader View
  MainView = Backbone.View.extend
    el: $("body")
    template: templates.base

    initialize: ->
      @vehiclesView = new VehiclesView

    render: ->
      $(@el).html Mustache.render @template
      @

    addContent: ->
      $("div#head_nav", @el).html Breadcrumbs.el
      $("div#content", @el).html @vehiclesView.el
      @

  # Create the app
  mainView = new MainView
  mainView.render().addContent()
