(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  $(function() {
    var CenterContainerView, MainView, ToolBarView, Vehicle, VehicleDetailView, VehicleList, VehicleView, Vehicles, VehiclesView, mainView, templates;
    templates = {};
    templates.base = '\
  <div class="header">\
      <h1>ZoomZoom</h1>\
      <div class="subtitle">Maintenance logger for your vehicles</div>\
  </div>\
  ';
    templates.center = '\
  <h2 class="vehicle_name">Just a title</h2>\
  ';
    templates.vehicle = '\
  <span class="vehicle_name">{{name}}</span><span class="del">x</span>\
  ';
    templates.vehicles = '\
  <h3 class="vehicles">Vehicles</h3>\
  <span class="count"></span>\
  <ul class="each_vehicle"></ul>\
  <input type="text" class="name" placeholder="Type new vehicle name"></input>\
  <br />\
  <button class="add_vehicle">Add Vehicle</button>\
  <div id="dialog" title="Confirm">\
    <p>\
      <span class="ui-icon ui-icon-alert" style="float: left; margin: .2em .2em 0 0;"></span>\
      This vehicle and all associated maintenance items will be permanently deleted and cannot be recovered. Are you sure?\
    </p>\
  </div>\
  ';
    templates.toolbar = '';
    templates.vehicle_detail = '<h2 class="vehicle_name">{{name}}</h2>';
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
    VehicleList = (function(_super) {

      __extends(VehicleList, _super);

      function VehicleList() {
        VehicleList.__super__.constructor.apply(this, arguments);
      }

      VehicleList.prototype.model = Vehicle;

      VehicleList.prototype.localStorage = new Store("vehicles-backbone");

      return VehicleList;

    })(Backbone.Collection);
    Vehicles = new VehicleList;
    ToolBarView = Backbone.View.extend({
      tagName: "div",
      className: "toolbar",
      template: templates.toolbar,
      render: function() {
        var vehiclesView;
        $(this.el).html(Mustache.render(this.template));
        vehiclesView = new VehiclesView;
        $(this.el).append(vehiclesView.el);
        return this;
      }
    });
    VehicleDetailView = Backbone.View.extend({
      tagName: "div",
      className: "vehicle_detail",
      template: templates.vehicle_detail,
      render: function() {
        $(this.el).html(Mustache.render(this.template, this.model.attributes));
        return this;
      }
    });
    VehicleView = Backbone.View.extend({
      tagName: "li",
      className: "vehicle",
      template: templates.vehicle,
      events: {
        'click span.del': 'delVehicle',
        'click span.vehicle_name': 'showDetails'
      },
      initialize: function() {
        return Vehicles.bind('remove', this.removeEl);
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template, this.model.attributes));
        return this;
      },
      delVehicle: function() {
        var _this = this;
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
        var vehicleDetailView;
        vehicleDetailView = new VehicleDetailView({
          model: this.model
        });
        return $('div.center_container').html(vehicleDetailView.render().el);
      }
    });
    VehiclesView = Backbone.View.extend({
      tagName: "div",
      className: "vehicles",
      template: templates.vehicles,
      events: {
        'click .add_vehicle': 'createVehicle',
        'keypress input.name': 'keyListner'
      },
      initialize: function() {
        Vehicles.bind('add', this.addOne, this);
        Vehicles.bind('all', this.updateCount, this);
        Vehicles.bind('reset', this.addAll, this);
        Vehicles.bind('remove', this.removeEl, this);
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
      keyListner: function(key) {
        if (key.keyCode === 13) this.createVehicle();
        return this;
      }
    });
    CenterContainerView = Backbone.View.extend({
      tagName: "div",
      className: "center_container",
      template: templates.center,
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
        return this.centerContainerView = new CenterContainerView;
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template));
        $(this.el).append(this.toolBarView.render().el);
        $(this.el).append(this.centerContainerView.render().el);
        return this;
      }
    });
    mainView = new MainView;
    return mainView.render();
  });

}).call(this);
