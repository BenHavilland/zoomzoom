(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  $(function() {
    var CenterContainerView, LogItem, LogItemView, LogItems, LogView, MainView, RightContainerView, ToolBarView, Vehicle, VehicleAddLogView, VehicleList, VehicleView, Vehicles, VehiclesView, mainView, templates;
    templates = {};
    templates.base = '\
  <div class="header">\
      <h1>ZoomZoom</h1>\
      <div class="subtitle">Maintenance logger for your vehicles</div>\
      <div id="dialog" title="Confirm">\
        <p>\
          <span class="ui-icon ui-icon-alert" style="float: left; margin: .2em .2em 0 0;"></span>\
          <span class="alert_content"></span>\
        </p>\
      </div>\
  </div>\
  ';
    templates.center = '\
  ';
    templates.right = '\
  ';
    templates.vehicle = '\
  <span class="menu">{{name}}</span><span class="del">x</span>\
  ';
    templates.vehicles = '\
  <div class="title">\
    <h3 class="vehicles">Vehicles</h3>\
    <span class="count"></span>\
    <span class="show_hide">...</span>\
  </div>\
  <div class="view_container">\
    <ul class="each_vehicle"></ul>\
    <input type="text" class="name" placeholder="Type new vehicle name" />\
    <button class="add_vehicle">Add Vehicle</button>\
  </div>\
  ';
    templates.toolbar = '';
    templates.vehicle_log = '\
  <div class="title">\
    <h3 class="vehicle_name">{{name}}</h3>\
    <span class="show_hide">...</span>\
  </div>\
  <div class="view_container">\
    <ul class="log"></ul>\
  </div>\
  ';
    templates.vehicle_log_item = '\
  <span class="menu">\
    <span>{{title}}</span>\
    <span class="cost">{{cost}}</span>\
  </span>\
  <span class="del">x</span>\
  ';
    templates.vehicle_add_log = '\
  <div class="title">\
    <h3 class="add_log_title">Add Log Entry</h3>\
    <span class="show_hide">...</span>\
  </div>\
  <div class="view_container">\
    <input type="text" id="miles" class="log miles" placeholder="Mileage at time of work" />\
    <input type="text" id="title" class="log title" placeholder="Title" />\
    <input type="text" id="description" class="log desc" placeholder="Description" />\
    <input type="text" id="cost" class="log cost" placeholder="Cost" />\
    <button class="add_log">Add Log Entry</button>\
  </div>\
  ';
    Vehicle = (function(_super) {

      __extends(Vehicle, _super);

      function Vehicle() {
        Vehicle.__super__.constructor.apply(this, arguments);
      }

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
    ToolBarView = Backbone.View.extend({
      tagName: "div",
      className: "toolbar panel",
      template: templates.toolbar,
      render: function() {
        var vehiclesView;
        $(this.el).html(Mustache.render(this.template));
        vehiclesView = new VehiclesView;
        $(this.el).append(vehiclesView.el);
        return this;
      }
    });
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
        'click div.title': 'toggleVisible'
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template, this.model.attributes));
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
        _.each(LogItems.where({
          "vehicleId": this.model.id
        }), this.addOne, this);
        return this;
      },
      toggleVisible: function() {
        this.$('.view_container', this.el).toggle();
        this.$('.show_hide', this.el).toggleClass('show_hide_show');
        this.$('div.title', this.el).toggleClass('add_margin');
        return this;
      }
    });
    LogItemView = Backbone.View.extend({
      tagName: "li",
      className: "menu",
      template: templates.vehicle_log_item,
      events: {
        'click span.del': 'delLogItem'
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template, this.model.attributes));
        return this;
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
                  return $(_this.el).remove();
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
    VehicleAddLogView = Backbone.View.extend({
      tagName: "div",
      className: "vehicle_add_log",
      template: templates.vehicle_add_log,
      events: {
        'click button.add_log': 'createLogItem',
        'keypress input': 'keyListener',
        'click div.title': 'toggleVisible'
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template, this.model.attributes));
        return this;
      },
      createLogItem: function() {
        var form_vals;
        if (!this.$('input.title').val()) return;
        form_vals = {};
        form_vals.vehicleId = this.model.id;
        _.each(this.$('input'), function(field) {
          return form_vals[$(field).attr('id')] = $(field).val();
        });
        console.log(form_vals);
        LogItems.create(form_vals);
        this.$('input').val('');
        return this;
      },
      keyListener: function(key) {
        if (key.keyCode === 13) this.createLogItem();
        return this;
      },
      toggleVisible: function() {
        this.$('.view_container', this.el).toggle();
        this.$('.show_hide', this.el).toggleClass('show_hide_show');
        this.$('div.title', this.el).toggleClass('add_margin');
        return this;
      }
    });
    VehicleView = Backbone.View.extend({
      tagName: "li",
      className: "menu",
      template: templates.vehicle,
      events: {
        'click span.del': 'delVehicle',
        'click span.menu': 'showDetails'
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template, this.model.attributes));
        return this;
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
                  return $(_this.el).remove();
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
      showDetails: function() {
        var vehicleAddLogView, vehicleLogView;
        vehicleLogView = new LogView({
          model: this.model
        });
        $('div.center_container').html(vehicleLogView.addAll().el);
        vehicleAddLogView = new VehicleAddLogView({
          model: this.model
        });
        return $('div.right_container').html(vehicleAddLogView.render().el);
      }
    });
    VehiclesView = Backbone.View.extend({
      tagName: "div",
      className: "vehicles",
      template: templates.vehicles,
      events: {
        'click .add_vehicle': 'createVehicle',
        'keypress input.name': 'keyListener',
        'click div.title': 'toggleVisible'
      },
      initialize: function() {
        Vehicles.bind('add', this.addOne, this);
        Vehicles.bind('all', this.updateCount, this);
        Vehicles.bind('reset', this.addAll, this);
        return Vehicles.fetch();
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template));
        return this;
      },
      updateCount: function() {
        return this.$("span.count").html("(" + Vehicles.length + ")");
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
      createVehicle: function() {
        this.input_vehicle_name = this.$('input.name');
        if (!this.input_vehicle_name.val()) return;
        Vehicles.create({
          name: this.input_vehicle_name.val()
        });
        this.input_vehicle_name.val('');
        return this;
      },
      keyListener: function(key) {
        if (key.keyCode === 13) this.createVehicle();
        return this;
      },
      toggleVisible: function() {
        this.$('.view_container', this.el).toggle();
        this.$('.show_hide', this.el).toggleClass('show_hide_show');
        this.$('div.title', this.el).toggleClass('add_margin');
        return this;
      }
    });
    CenterContainerView = Backbone.View.extend({
      tagName: "div",
      className: "center_container panel",
      template: templates.center,
      render: function() {
        $(this.el).html(Mustache.render(this.template));
        return this;
      }
    });
    RightContainerView = Backbone.View.extend({
      tagName: "div",
      className: "right_container panel",
      template: templates.right,
      render: function() {
        $(this.el).html(Mustache.render(this.template));
        return this;
      }
    });
    MainView = Backbone.View.extend({
      el: $("body"),
      template: templates.base,
      initialize: function() {
        this.toolBarView = new ToolBarView;
        this.centerContainerView = new CenterContainerView;
        return this.rightContainerView = new RightContainerView;
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template));
        $(this.el).append(this.toolBarView.render().el);
        $(this.el).append(this.centerContainerView.render().el);
        $(this.el).append(this.rightContainerView.render().el);
        return this;
      }
    });
    mainView = new MainView;
    return mainView.render();
  });

}).call(this);
