(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  $(function() {
    var BreadcrumbView, Breadcrumbs, BreadcrumbsView, FullLogItemView, LogItem, LogItemView, LogItems, LogView, MainView, Notifier, NotifyView, Vehicle, VehicleAddLogView, VehicleAddView, VehicleEditLogView, VehicleEditView, VehicleList, VehicleView, Vehicles, VehiclesView, mainView, templates;
    templates = {};
    templates.base = '<div class="header">\
    <h1>ZoomZoom</h1>\
    <div class="subtitle">Maintenance logger for your vehicles</div>\
  </div>\
  <div id="head_nav"></div>\
  <div id="content"></div>\
  <div id="dialog" title="Confirm">\
    <p>\
      <span class="ui-icon ui-icon-alert" style="float: left; margin: .2em .2em 0 0;"></span>\
      <span class="alert_content"></span>\
    </p>\
  </div>';
    templates.notify = '<div id="left"></div>\
  <div id="right"></div>\
  <div id="top"></div>\
  <div id="bottom"></div>';
    templates.breadcrumb = '{{title}}';
    templates.breadcrumbs = '';
    templates.vehicle = '<span class="menu">{{name}}</span>';
    templates.vehicles = '<div class="view_container">\
    <ul class="each_vehicle"></ul>\
    <button class="add_vehicle">Add Vehicle</button>\
  </div>';
    templates.vehicle_add = '<div class="view_container">\
    <input type="text" class="name" placeholder="Type new vehicle name" />\
    <button class="add_vehicle">Add Vehicle</button>\
  </div>';
    templates.vehicle_edit = '<div class="view_container">\
    <input type="text" class="name" placeholder="Type new vehicle name" value="{{name}}" />\
    <button class="save">Save</button>\
  </div>';
    templates.vehicle_log = '<div class="view_container">\
    <ul class="log"></ul>\
  </div>\
  <div>\
    <button class="add_log_item">Add Log Item</button>\
    <button class="edit">Edit Vehicle</button>\
    <button class="delete">Delete Vehicle</button>\
  </div>';
    templates.vehicle_log_item = '<span class="menu">\
    <span class="title">{{title}}</span>\
  </span>';
    templates.vehicle_log_item_full = '<div class="view_container">\
    <ul>\
      <li>\
        <span class="label">Miles:</span>\
        <span class="miles">{{miles}}</span>\
      </li>\
      <li>\
        <span class="label">Cost:</span>\
        <span class="cost">{{cost}}</span>\
      </li>\
      <li>\
        <span class="label">Description:</span>\
        <span class="description">{{description}}</span>\
      </li>\
    </ul>\
  </div>\
  <div>\
    <button class="edit">Edit Log Item</button>\
    <button class="delete">Delete Log Item</button>\
  </div>';
    templates.vehicle_add_log = '<div class="view_container">\
    {{#vehicleId}}\
    <input type="hidden" value="{{vehicleId}}" id="vehicleId"/>\
    {{/vehicleId}}\
    <input type="text" id="miles" class="log miles" placeholder="Mileage at time of work" value="{{miles}}" />\
    <input type="text" id="title" class="log title" placeholder="Title" value="{{title}}" maxlength="40"/>\
    <textarea id="description" class="log description" placeholder="Description">{{description}}</textarea>\
    <input type="text" id="cost" class="log cost" placeholder="Cost" value="{{cost}}" />\
    <button class="add_log">Add Log Entry</button>\
  </div>';
    templates.vehicle_edit_log = '<div class="view_container">\
    {{#id}}\
    <input type="hidden" value="{{id}}" id="id"/>\
    {{/id}}\
    {{#vehicleId}}\
    <input type="hidden" value="{{vehicleId}}" id="vehicleId"/>\
    {{/vehicleId}}\
    <input type="text" id="miles" class="log miles" placeholder="Mileage at time of work" value="{{miles}}" />\
    <input type="text" id="title" class="log title" placeholder="Title" value="{{title}}" maxlength="40"/>\
    <textarea id="description" class="log description" placeholder="Description">{{description}}</textarea>\
    <input type="text" id="cost" class="log cost" placeholder="Cost" value="{{cost}}" />\
    <button class="add_log">Add Log Entry</button>\
  </div>';
    Vehicle = (function(_super) {

      __extends(Vehicle, _super);

      function Vehicle() {
        Vehicle.__super__.constructor.apply(this, arguments);
      }

      Vehicle.prototype.name = "Vehicle";

      Vehicle.prototype.defaults = function() {
        return {
          isAwesome: "yes"
        };
      };

      Vehicle.prototype.initialize = function() {
        return console.log("vehicle initialized");
      };

      return Vehicle;

    })(Backbone.Model);
    LogItem = (function(_super) {

      __extends(LogItem, _super);

      function LogItem() {
        LogItem.__super__.constructor.apply(this, arguments);
      }

      LogItem.prototype.name = "LogItem";

      LogItem.prototype.defaults = function() {
        return {
          added: new Date()
        };
      };

      LogItem.prototype.initialize = function() {
        return console.log("log item initialized");
      };

      return LogItem;

    })(Backbone.Model);
    VehicleList = (function(_super) {

      __extends(VehicleList, _super);

      function VehicleList() {
        VehicleList.__super__.constructor.apply(this, arguments);
      }

      VehicleList.prototype.model = Vehicle;

      VehicleList.prototype.localStorage = new Store("vehicles-backbone");

      return VehicleList;

    })(Backbone.Collection);
    LogItems = (function(_super) {

      __extends(LogItems, _super);

      function LogItems() {
        LogItems.__super__.constructor.apply(this, arguments);
      }

      LogItems.prototype.model = LogItem;

      LogItems.prototype.localStorage = new Store("vehicle-logs-backbone");

      return LogItems;

    })(Backbone.Collection);
    Vehicles = new VehicleList;
    LogItems = new LogItems;
    LogItems.fetch();
    NotifyView = Backbone.View.extend({
      tagName: 'div',
      className: 'notify',
      template: templates.notify,
      render: function() {
        $(this.el).html(Mustache.render(this.template));
        return this;
      },
      success: function(message) {
        $(this.el).children().removeClass('failure').addClass('success').fadeIn('slow', function() {
          return $(this).fadeOut('slow');
        });
        return this;
      },
      failure: function() {
        if (navigator.notification) navigator.notification.vibrate(250);
        $(this.el).children().removeClass('success').addClass('failure').fadeIn('slow', function() {
          return $(this).fadeOut('slow');
        });
        return this;
      }
    });
    Notifier = new NotifyView;
    LogView = Backbone.View.extend({
      tagName: "div",
      className: "vehicle_log",
      template: templates.vehicle_log,
      initialize: function() {
        LogItems.where({
          "vehicleId": this.model.id
        });
        LogItems.bind('add', this.addOne, this);
        LogItems.bind('reset', this.addAll, this);
        return this.render();
      },
      events: {
        'click button.add_log_item': 'showAddLog',
        'click button.edit': 'showEditVehicle',
        'click button.delete': 'delVehicle'
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template, this.model.attributes));
        Breadcrumbs.addOne(this.model);
        return this;
      },
      addOne: function(logItem) {
        var logItemView;
        logItemView = new LogItemView({
          model: logItem
        });
        this.$("ul.log").append(logItemView.render().el);
        return this;
      },
      addAll: function() {
        var logItems;
        logItems = LogItems.where({
          "vehicleId": this.model.id
        });
        if (logItems[0]) {
          _.each(logItems, this.addOne, this);
        } else {
          this.$("ul.log").html("No log items.");
        }
        return this;
      },
      showAddLog: function() {
        var vehicleAddLogView;
        vehicleAddLogView = new VehicleAddLogView({
          model: this.model
        });
        $('div#content').html(vehicleAddLogView.render().el);
        return Breadcrumbs.addOne("Add Log Item");
      },
      showEditVehicle: function() {
        var vehicleEditView;
        vehicleEditView = new VehicleEditView({
          model: this.model
        });
        $('div#content').html(vehicleEditView.render().el);
        return Breadcrumbs.addOne("Edit");
      },
      delVehicle: function() {
        var _this = this;
        $("span.alert_content").html("This vehicle and all associated maintenance items will be permanently deleted and cannot be recovered. Are you sure?");
        $("div#dialog").dialog({
          resizable: false,
          modal: true,
          width: "50%",
          title: "Confirm Delete",
          buttons: {
            "Delete": function() {
              $("div#dialog").dialog("close");
              return _this.model.destroy({
                success: function() {
                  $(_this.el).remove();
                  return Notifier.success("Vehicle Deleted");
                }
              });
            },
            Cancel: function() {
              return $(this).dialog("close");
            }
          }
        });
        return this;
      },
      alertDismissed: function() {
        return this;
      }
    });
    FullLogItemView = Backbone.View.extend({
      tagName: "div",
      className: "full_log",
      template: templates.vehicle_log_item_full,
      events: {
        'click button.delete': 'delLogItem',
        'click button.edit': 'editLogItem'
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template, this.model.attributes));
        return this;
      },
      addCrumb: function() {
        Breadcrumbs.addOne(this.model);
        return this;
      },
      editLogItem: function() {
        var vehicleEditLogView;
        vehicleEditLogView = new VehicleEditLogView({
          model: this.model
        });
        $('div#content').html(vehicleEditLogView.render().el);
        $('button.add_log').html("Save");
        return Breadcrumbs.addOne("Edit");
      },
      delLogItem: function() {
        var _this = this;
        $("span.alert_content").html("This maintenance item will be permanently deleted and cannot be recovered. Are you sure?");
        $("div#dialog").dialog({
          resizable: false,
          modal: true,
          width: "50%",
          title: "Confirm Delete",
          buttons: {
            "Delete": function() {
              $("div#dialog").dialog("close");
              return _this.model.destroy({
                success: function() {
                  $(_this.el).remove();
                  return Notifier.success("Log Item Deleted");
                }
              });
            },
            Cancel: function() {
              return $(this).dialog("close");
            }
          }
        });
        return this;
      }
    });
    LogItemView = Backbone.View.extend({
      tagName: "li",
      className: "menu",
      template: templates.vehicle_log_item,
      events: {
        'click span.menu': 'renderFull'
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template, this.model.attributes));
        return this;
      },
      renderFull: function() {
        var fullLogItemView;
        fullLogItemView = new FullLogItemView({
          model: this.model
        });
        $('div#content').html(fullLogItemView.render().el);
        return Breadcrumbs.addOne(this.model);
      }
    });
    VehicleEditLogView = Backbone.View.extend({
      tagName: "div",
      className: "vehicle_edit_log",
      template: templates.vehicle_edit_log,
      events: {
        'click button.add_log': 'saveLogItem',
        'keypress input': 'keyListener'
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template, this.model.attributes));
        return this;
      },
      keyListener: function(key) {
        if (key.keyCode === 13) this.saveLogItem();
        return this;
      },
      saveLogItem: function() {
        var form_vals, logItem;
        if (!this.$('input.title').val()) {
          Notifier.failure("Title required");
          return;
        }
        form_vals = {};
        form_vals.vehicleId = this.model.id;
        _.each(this.$('input'), function(field) {
          return form_vals[$(field).attr('id')] = $(field).val();
        });
        _.each(this.$('textarea'), function(field) {
          return form_vals[$(field).attr('id')] = $(field).val();
        });
        logItem = LogItems.get(form_vals.id);
        logItem.save(form_vals, {
          success: function() {
            return Notifier.success("Log item saved");
          }
        });
        return this;
      }
    });
    VehicleAddLogView = Backbone.View.extend({
      tagName: "div",
      className: "vehicle_add_log",
      template: templates.vehicle_add_log,
      events: {
        'click button.add_log': 'createLogItem',
        'keypress input': 'keyListener'
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template, this.model.attributes));
        return this;
      },
      createLogItem: function() {
        var form_vals;
        if (!this.$('input.title').val()) {
          Notifier.failure("Title required");
          return;
        }
        form_vals = {};
        form_vals.vehicleId = this.model.id;
        _.each(this.$('input'), function(field) {
          return form_vals[$(field).attr('id')] = $(field).val();
        });
        _.each(this.$('textarea'), function(field) {
          return form_vals[$(field).attr('id')] = $(field).val();
        });
        LogItems.create(form_vals, {
          success: function() {
            return Notifier.success("Created");
          }
        });
        this.$('input').val('');
        this.$('textarea').val('');
        return this;
      },
      keyListener: function(key) {
        if (key.keyCode === 13) this.createLogItem();
        return this;
      }
    });
    VehicleView = Backbone.View.extend({
      tagName: "li",
      className: "menu",
      template: templates.vehicle,
      events: {
        'click span.menu': 'showDetails'
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template, this.model.attributes));
        return this;
      },
      showDetails: function() {
        var vehicleLogView;
        vehicleLogView = new LogView({
          model: this.model
        });
        return $('div#content').html(vehicleLogView.addAll().el);
      }
    }, VehiclesView = Backbone.View.extend({
      tagName: "div",
      className: "vehicles",
      template: templates.vehicles,
      events: {
        'click .add_vehicle': 'showAdd'
      },
      initialize: function() {
        Vehicles.bind('add', this.addOne, this);
        Vehicles.bind('reset', this.addAll, this);
        return Vehicles.fetch();
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template));
        Breadcrumbs.render().addOne("Vehicles");
        return this;
      },
      addOne: function(vehicle) {
        var vehicleView;
        vehicleView = new VehicleView({
          model: vehicle
        });
        this.$("ul.each_vehicle").append(vehicleView.render().el);
        return this;
      },
      addAll: function() {
        this.render();
        Vehicles.each(this.addOne, this);
        return this;
      },
      showAdd: function() {
        var vehicleAddView;
        vehicleAddView = new VehicleAddView;
        $("div#content").html(vehicleAddView.render().el);
        Breadcrumbs.addOne("Add Vehicle");
        return this;
      }
    }));
    VehicleAddView = Backbone.View.extend({
      tagName: "div",
      classname: "vehicle_add",
      template: templates.vehicle_add,
      events: {
        'click .add_vehicle': 'createVehicle',
        'keypress input.name': 'keyListener'
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template));
        return this;
      },
      keyListener: function(key) {
        if (key.keyCode === 13) this.createVehicle();
        return this;
      },
      createVehicle: function() {
        this.input_vehicle_name = this.$('input.name');
        if (!this.input_vehicle_name.val()) {
          Notifier.failure("Name required");
          return;
        }
        Vehicles.create({
          name: this.input_vehicle_name.val()
        });
        this.input_vehicle_name.val('');
        Notifier.success("Vehicle Added");
        return this;
      }
    });
    VehicleEditView = Backbone.View.extend({
      tagName: "div",
      classname: "vehicle_add",
      template: templates.vehicle_edit,
      events: {
        'click button.save': 'saveVehicle'
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template, this.model.attributes));
        return this;
      },
      saveVehicle: function() {
        if (!this.$('input.name').val()) {
          Notifier.failure("Name required");
          return;
        }
        this.model.save({
          name: this.$('input.name').val()
        }, {
          success: function() {
            return Notifier.success("Log item saved");
          }
        });
        return this;
      }
    });
    BreadcrumbsView = Backbone.View.extend({
      tagName: 'ul',
      className: 'breadcrumbs',
      template: templates.breadcrumbs,
      render: function() {
        $(this.el).html(Mustache.render(this.template));
        return this;
      },
      addOne: function(model) {
        var breadcrumbView;
        breadcrumbView = new BreadcrumbView({
          model: model
        });
        $(this.el).append(breadcrumbView.render().el);
        return this;
      }
    });
    Breadcrumbs = new BreadcrumbsView;
    BreadcrumbView = Backbone.View.extend({
      tagName: 'li',
      className: 'breadcrumb',
      template: templates.breadcrumb,
      events: {
        'click': 'followBreadcrumb'
      },
      render: function() {
        var name, title;
        if (_.isObject(this.model)) {
          title = this.model.get("title");
          if (title) {
            $(this.el).html(Mustache.render(this.template, {
              title: title
            }));
            return this;
          }
          name = this.model.get("name");
          if (name) {
            $(this.el).html(Mustache.render(this.template, {
              title: name
            }));
            return this;
          }
        }
        if (_.isString(this.model)) {
          $(this.el).html(Mustache.render(this.template, {
            title: this.model
          }));
          return this;
        }
        return this;
      },
      followBreadcrumb: function() {
        var fullLogItemView, name, vehicleLogView, vehiclesView;
        name = $(this.el).html();
        if ($(this.el).is(':last-child')) return this;
        if (_.isString(this.model)) {
          if (name === "Vehicles") {
            vehiclesView = new VehiclesView;
            $("div#content").html(vehiclesView.el);
          }
          return this;
        }
        if (this.model.name === "Vehicle") {
          vehicleLogView = new LogView({
            model: this.model
          });
          this.removeCrumbs();
          $('div#content').html(vehicleLogView.render().addAll().el);
          return this;
        }
        if (this.model.name === "LogItem") {
          fullLogItemView = new FullLogItemView({
            model: this.model
          });
          this.removeCrumbs();
          $('div#content').html(fullLogItemView.render().addCrumb().el);
          return this;
        }
        return this;
      },
      removeCrumbs: function() {
        $(this.el).nextAll().remove();
        $(this.el).remove();
        return this;
      }
    });
    MainView = Backbone.View.extend({
      el: $("body"),
      template: templates.base,
      initialize: function() {
        return this.vehiclesView = new VehiclesView;
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template));
        return this;
      },
      addContent: function() {
        $("div#head_nav", this.el).html(Breadcrumbs.el);
        $("div#content", this.el).html(this.vehiclesView.el);
        $(this.el).append(Notifier.render().el);
        return this;
      }
    });
    mainView = new MainView;
    return mainView.render().addContent();
  });

}).call(this);
