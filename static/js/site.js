(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  $(function() {
    var ToolBar, ToolBarView, Vehicle, VehicleList, VehicleView, Vehicles, VehiclesView;
    $('body').fadeIn();
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
      template: "<p>This is just a local template doc  that will be \    changed in the near future.<p/> \    <p>Once we define out models we will add list items here like below.</p>    ",
      initialize: function() {
        var vehiclesView;
        $('body').append(this.render().el);
        vehiclesView = new VehiclesView;
        return $(this.el).append(vehiclesView.render().el);
      },
      render: function() {
        $(this.el).html(this.template);
        return this;
      }
    });
    VehicleView = Backbone.View.extend({
      tagName: "li",
      className: "vehicle",
      template: "Y{{year}} M{{make}} M{{model}}",
      render: function() {
        $(this.el).html(this.template);
        return this;
      }
    });
    VehiclesView = Backbone.View.extend({
      tagName: "div",
      className: "vehicles",
      template: "<h3>Cars</h3>      <ul>        <li>2001 Volvo V70 T5</li>        <li>1991 BMW 325ic</li>        <li>1976 Ford F350</li>      </ul>      <h3>Motorcycles</h3>      <ul>        <li>1980 Honda CB750</li>        <li>1980 Honda CM400T</li>        <li>1982 Honda CM250C</li>      </ul>",
      initialize: function() {
        Vehicles.bind('reset', this.addAll, this);
        return Vehicles.fetch();
      },
      render: function() {
        $(this.el).html(this.template);
        return this;
      },
      addOne: function(vehicle) {
        var vehicleView;
        console.log('here is one vehicle');
        vehicleView = new VehicleView({
          model: vehicle
        });
        $(this.el).append(vehicleView.render().el);
        return this;
      },
      addAll: function() {
        console.log('polling all');
        Vehicles.each(this.addOne);
        return this;
      }
    });
    return ToolBar = new ToolBarView;
  });

}).call(this);
