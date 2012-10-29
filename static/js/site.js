(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  $(function() {
    var ToolBar, ToolBarView, Vehicle, VehicleList, VehicleView, Vehicles, VehiclesView;
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
      events: {
        'click .add_vehicle': 'createVehicle'
      },
      template: "<h3 class='vehicles'>Vehicles</h3> <span class='count'></span>    <ul class='vehicles'></ul>    <input type='text' class='name' placeholder='Type new vehicle name'></input>    <br />    <button class='add_vehicle'>Add Vehicle</button>    ",
      initialize: function() {
        var vehiclesView;
        $('body').append(this.render().el);
        vehiclesView = new VehiclesView;
        $(this.el).append(vehiclesView.render().el);
        this.input_vehicle_name = this.$('input.name');
        return this;
      },
      render: function() {
        $(this.el).html(this.template);
        return this;
      },
      createVehicle: function() {
        if (!this.input_vehicle_name.val()) return;
        Vehicles.create({
          name: this.input_vehicle_name.val()
        });
        this.input_vehicle_name.val('');
        return this;
      }
    });
    VehicleView = Backbone.View.extend({
      tagName: "li",
      className: "vehicle",
      template: "{{vehicle.titlel}}",
      render: function() {
        $(this.el).html(this.model.get('name'));
        console.log(this.model);
        return this;
      }
    });
    VehiclesView = Backbone.View.extend({
      el: $("div.toolbar"),
      initialize: function() {
        Vehicles.bind('add', this.addOne, this);
        Vehicles.bind('all', this.render, this);
        Vehicles.bind('reset', this.addAll, this);
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
