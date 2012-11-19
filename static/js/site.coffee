# Load the application once the DOM is ready, using `jQuery.ready`:
$ ->

  # Templates=
  templates = {}
  templates.base =
  '<div class="header">
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
  </div>'
  templates.notify =
  '<div id="left"></div>
  <div id="right"></div>
  <div id="top"></div>
  <div id="bottom"></div>'
  templates.breadcrumb = '{{title}}'
  templates.breadcrumbs = ''
  templates.vehicle = '<span class="menu">{{name}}</span>'
  templates.vehicles =
  '<div class="view_container">
    <ul class="each_vehicle"></ul>
    <button class="add_vehicle">Add Vehicle</button>
  </div>'
  templates.vehicle_add =
  '<div class="view_container">
    <input type="text" class="name" placeholder="Type new vehicle name" />
    <button class="add_vehicle">Add Vehicle</button>
  </div>'
  templates.vehicle_edit =
  '<div class="view_container">
    <input type="text" class="name" placeholder="Type new vehicle name" value="{{name}}" />
    <button class="save">Save</button>
  </div>'
  templates.vehicle_log =
  '<div class="view_container">
    <ul class="log"></ul>
  </div>
  <div>
    <button class="add_log_item">Add Log Item</button>
    <button class="edit">Edit Vehicle</button>
    <button class="delete">Delete Vehicle</button>
  </div>'
  templates.vehicle_log_item =
  '<span class="menu">
    <span class="title">{{title}}</span>
  </span>'
  templates.vehicle_log_item_full =
  '<div class="view_container">
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
  </div>'
  templates.vehicle_add_log =
  '<div class="view_container">
    {{#vehicleId}}
    <input type="hidden" value="{{vehicleId}}" id="vehicleId"/>
    {{/vehicleId}}
    <input type="text" id="miles" class="log miles" placeholder="Mileage at time of work" value="{{miles}}" />
    <input type="text" id="title" class="log title" placeholder="Title" value="{{title}}" maxlength="40"/>
    <textarea id="description" class="log description" placeholder="Description">{{description}}</textarea>
    <input type="text" id="cost" class="log cost" placeholder="Cost" value="{{cost}}" />
    <button class="add_log">Add Log Entry</button>
  </div>'

  templates.vehicle_edit_log =
  '<div class="view_container">
    {{#id}}
    <input type="hidden" value="{{id}}" id="id"/>
    {{/id}}
    {{#vehicleId}}
    <input type="hidden" value="{{vehicleId}}" id="vehicleId"/>
    {{/vehicleId}}
    <input type="text" id="miles" class="log miles" placeholder="Mileage at time of work" value="{{miles}}" />
    <input type="text" id="title" class="log title" placeholder="Title" value="{{title}}" maxlength="40"/>
    <textarea id="description" class="log description" placeholder="Description">{{description}}</textarea>
    <input type="text" id="cost" class="log cost" placeholder="Cost" value="{{cost}}" />
    <button class="add_log">Add Log Entry</button>
  </div>'

  # Models
  class Vehicle extends Backbone.Model
    name: "Vehicle"
    # make all vehicles awesome
    defaults: ->
      isAwesome: "yes"

    initialize: ->
      # tell the browser console that we're taking the vehicle model for a spin
      console.log "vehicle initialized"

  class LogItem extends Backbone.Model
    name: "LogItem"
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
  NotifyView = Backbone.View.extend
    tagName: 'div'
    className: 'notify'
    template: templates.notify

    render: ->
      $(@el).html Mustache.render @template
      @

    success: (message) ->
      $(@el)
      .children()
      .removeClass('failure')
      .addClass('success')
      .fadeIn 'slow', ->
        $(@).fadeOut 'slow'
      @

    failure: ->
      if navigator.notification
        navigator.notification.vibrate 250
      $(@el)
      .children()
      .removeClass('success')
      .addClass('failure')
      .fadeIn 'slow', ->
        $(@).fadeOut 'slow'
      @

  # we need throughout the app
  Notifier = new NotifyView

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
      'click button.edit': 'showEditVehicle'
      'click button.delete':'delVehicle'

    render: ->
      $(@el).html Mustache.render @template, @model.attributes
      Breadcrumbs.addOne(@model)
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

    showEditVehicle: ->
      vehicleEditView = new VehicleEditView model:@model
      $('div#content').html vehicleEditView.render().el
      Breadcrumbs.addOne("Edit")

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
                  Notifier.success("Vehicle Deleted")
            Cancel: ->
                # clicked cancel, don't delete it. just close the dialog
                $(@).dialog( "close" )
      @

    alertDismissed: ->
      @

  FullLogItemView = Backbone.View.extend
    tagName: "div"
    className: "full_log"
    template: templates.vehicle_log_item_full

    events:
      'click button.delete':'delLogItem'
      'click button.edit':'editLogItem'

    render: ->
      $(@el).html Mustache.render @template, @model.attributes
      @

    addCrumb: ->
      Breadcrumbs.addOne(@model)
      @

    editLogItem: ->
      vehicleEditLogView = new VehicleEditLogView model:@model
      $('div#content').html vehicleEditLogView.render().el
      $('button.add_log').html("Save")
      Breadcrumbs.addOne("Edit")

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
                  Notifier.success("Log Item Deleted")
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
      Breadcrumbs.addOne(@model)

  VehicleEditLogView = Backbone.View.extend
    tagName: "div"
    className: "vehicle_edit_log"
    template: templates.vehicle_edit_log

    events:
      'click button.add_log': 'saveLogItem'
      'keypress input'  : 'keyListener'

    render: ->
      $(@el).html Mustache.render @template, @model.attributes
      @

    keyListener: (key) ->
      # let the user press -return- key unstead of clicking Add
      if key.keyCode is 13
        @saveLogItem()
      @

    saveLogItem: ->
      # if there is text in the log title field we'll create it
      if !@$('input.title').val()
        Notifier.failure("Title required")
        return
      form_vals = {}
      form_vals.vehicleId = @model.id
      _.each @$('input'), (field) ->
        form_vals[$(field).attr('id')] = $(field).val()
      _.each @$('textarea'), (field) ->
        form_vals[$(field).attr('id')] = $(field).val()
      logItem = LogItems.get form_vals.id
      logItem.save form_vals,
        success: ->
          Notifier.success("Log item saved")
      @

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
        Notifier.failure("Title required")
        return
      form_vals = {}
      form_vals.vehicleId = @model.id
      _.each @$('input'), (field) ->
        form_vals[$(field).attr('id')] = $(field).val()
      _.each @$('textarea'), (field) ->
        form_vals[$(field).attr('id')] = $(field).val()
      LogItems.create form_vals,
        success: ->
          Notifier.success("Created")
      # clear the text in all fields to prepare for next input
      @$('input').val('')
      @$('textarea').val('')
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

    VehiclesView = Backbone.View.extend
      tagName: "div"
      className: "vehicles"
      template: templates.vehicles

      events:
        'click .add_vehicle' : 'showAdd'

      initialize: ->
        # make things happen when the collection updates
        Vehicles.bind 'add', @addOne, @
        Vehicles.bind 'reset', @addAll, @
        # load in the vehicles
        Vehicles.fetch()

      render: ->
        $(@el).html Mustache.render @template
        Breadcrumbs.render().addOne("Vehicles")
        @

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

      showAdd: ->
        vehicleAddView = new VehicleAddView
        $("div#content").html vehicleAddView.render().el
        Breadcrumbs.addOne("Add Vehicle")
        @

  VehicleAddView = Backbone.View.extend
    tagName: "div"
    classname: "vehicle_add"
    template: templates.vehicle_add

    events:
      'click .add_vehicle' : 'createVehicle'
      'keypress input.name' : 'keyListener'

    render: ->
      $(@el).html Mustache.render @template
      @

    keyListener: (key) ->
      # let the user press -return- key unstead of clicking Add
      if key.keyCode is 13
        @createVehicle()
      @

    createVehicle: ->
      @input_vehicle_name = @$('input.name')
      # if there is text in the vehicle name field create it
      if !@input_vehicle_name.val()
        Notifier.failure("Name required")
        return
      Vehicles.create({name: @input_vehicle_name.val()})
      # clear the text to prepare for next input
      @input_vehicle_name.val('')
      Notifier.success("Vehicle Added")
      @

  VehicleEditView = Backbone.View.extend
    tagName: "div"
    classname: "vehicle_add"
    template: templates.vehicle_edit

    events:
      'click button.save': 'saveVehicle'

    render: ->
      $(@el).html Mustache.render @template, @model.attributes
      @

    saveVehicle: ->
      # if there is text in the log title field we'll create it
      if !@$('input.name').val()
        Notifier.failure("Name required")
        return
      @model.save {name:@$('input.name').val()}
        success: ->
          Notifier.success("Log item saved")
      @

  BreadcrumbsView = Backbone.View.extend
    tagName: 'ul'
    className: 'breadcrumbs'
    template: templates.breadcrumbs

    render: ->
      $(@el).html Mustache.render @template
      @

    addOne: (model) ->
      breadcrumbView = new BreadcrumbView model:model
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
      if _.isObject @model

        title = @model.get "title"
        if title
          $(@el).html Mustache.render @template ,title: title
          return @

        name = @model.get "name"
        if name
          $(@el).html Mustache.render @template ,title: name
          return @

      if _.isString @model
        $(@el).html Mustache.render @template ,title: @model
        return @
      @

    followBreadcrumb: ->
      name = $(@el).html()

      # if it's the last item on the list disable nav
      if $(@el).is(':last-child')
        return @

      # if it's just text do a check
      if _.isString @model
        if name is "Vehicles"
          vehiclesView = new VehiclesView
          $("div#content").html vehiclesView.el
        return @

      if @model.name is "Vehicle"
        vehicleLogView = new LogView model:@model
        @removeCrumbs()
        $('div#content').html vehicleLogView.render().addAll().el
        return @

      if @model.name is "LogItem"
        fullLogItemView = new FullLogItemView model:@model
        @removeCrumbs()
        $('div#content').html fullLogItemView.render().addCrumb().el
        return @

      @

    removeCrumbs: ->
      $(@el).nextAll().remove()
      $(@el).remove()
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
      $(@el).append Notifier.render().el
      @

  # Create the app
  mainView = new MainView
  mainView.render().addContent()
