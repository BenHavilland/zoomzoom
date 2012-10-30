(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  $(function() {
    var ToolBar, ToolBarView, Vehicle, VehicleList, VehicleView, Vehicles, VehiclesView, templates;
    templates = {};
    templates.vehicle = '\
  <span class="vehicle_name">{{name}}</span><span class="del">x</span>\
  ';
    templates.toolbar = '<h3 class="vehicles">Vehicles</h3>\
  <span class="count"></span>\
  <ul class="vehicles"></ul>\
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
      events: {
        'click .add_vehicle': 'createVehicle',
        'keypress input.name': 'keyListner'
      },
      initialize: function() {
        var vehiclesView;
        $('body').append(this.render().el);
        vehiclesView = new VehiclesView;
        $(this.el).append(vehiclesView.render().el);
        this.input_vehicle_name = this.$('input.name');
        return this;
      },
      render: function() {
        $(this.el).html(Mustache.render(this.template));
        return this;
      },
      createVehicle: function() {
        if (!this.input_vehicle_name.val()) return;
        Vehicles.create({
          name: this.input_vehicle_name.val()
        });
        this.input_vehicle_name.val('');
        return this;
      },
      keyListner: function(key) {
        if (key.keyCode === 13) return this.createVehicle();
      }
    });
    VehicleView = Backbone.View.extend({
      tagName: "li",
      className: "vehicle",
      template: templates.vehicle,
      events: {
        'click span.del': 'delVehicle'
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
      }
    });
    VehiclesView = Backbone.View.extend({
      el: $("div.toolbar"),
      initialize: function() {
        Vehicles.bind('add', this.addOne, this);
        Vehicles.bind('all', this.render, this);
        Vehicles.bind('reset', this.addAll, this);
        Vehicles.bind('remove', this.removeEl, this);
        return Vehicles.fetch();
      },
      render: function() {
        $("span.count").html("(" + Vehicles.length + ")");
        return this;
      },
      addOne: function(vehicle) {
        var vehicleView;
        vehicleView = new VehicleView({
          model: vehicle
        });
        $("ul.vehicles").append(vehicleView.render().el);
        return this;
      },
      addAll: function() {
        Vehicles.each(this.addOne);
        return this;
      }
    });
    return ToolBar = new ToolBarView;
  });

}).call(this);
