(function() {

  $(function() {
    var BenView, ClickySpinner, ClickySpinnyView, CodeProjectsView, FogFudgeView, MainMenuView, MainView, WifiShelterView, ZoomZoomView, templates;
    templates = {};
    templates.base = '<div id="content"><div id="ben"></div><div id="main-container"></div><div id="menu"></div></div>';
    templates.ben = '\
  <a class="fork-me" href="https://github.com/clickyspinny">\
    <img style="position: absolute; top: 0; left: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_left_red_aa0000.png" alt="Fork me on GitHub">\
  </a>\
  <span class="floating-head">\
    <img src="static/img/floating_head_ben_crop_nohand.png" class="floating-head" />\
    <img src="static/img/floating_head_ben_crop.png" class="floating-head-hand" />\
  </span>\
  ';
    templates.code_projects = '<h2>PROJECTS</h2>\
  <ul>\
  <li>\
    FOG FUDGE&trade;: Mezzanine, Cartridge, venv, heroku deploy<br />\
    <a href="http://fogfudge.heroku.com">fogfudge.com</a><br />\
    <a href="https://github.com/clickyspinny/fogfudge">github.com/clickyspinny/fogfudge</a>\
  </li>\
  <li>\
    ZOOM ZOOM: Backbone.js + Coffeescript<br />\
    <a href="http://clickyspinny.com/zoomzoom/">clickyspinny.com/zoomzoom/</a><br />\
    <a href="https://github.com/clickyspinny/zoomzoom">github.com/clickyspinny/zoomzoom</a>\
  </li>\
  <li>\
    CLICKYSPINNY: This site silly. Backbone.js, Coffeescript, venv, heroku deploy<br />\
    <a href="http://clickyspinny.com">clickyspinny.com</a><br />\
    <a href="https://github.com/clickyspinny/clickyspinny.com">github.com/clickyspinny/clickyspinny.com</a>\
  </li>\
  </ul>\
  ';
    templates.fogfudge = '<h2>FOG FUDGE&trade;</h2>\
  <ul>\
  <li>\
    Mezzanine, Cartridge, venv, heroku deploy<br />\
    <a href="http://www.fogfudge.com">fogfudge.com</a><br />\
    <a href="https://github.com/clickyspinny/fogfudge">github.com/clickyspinny/fogfudge</a>\
  </li>\
  </ul>\
  ';
    templates.zoomzoom = '<h2>ZOOM ZOOM</h2>\
  <ul>\
  <li>\
    Backbone.js + Coffeescript<br />\
    <a href="http://clickyspinny.com/zoomzoom/">clickyspinny.com/zoomzoom/</a><br />\
    <a href="https://github.com/clickyspinny/zoomzoom">github.com/clickyspinny/zoomzoom</a>\
  </li>\
  </ul>\
  ';
    templates.wifishelter = '<h2>WIFI SHELTER</h2>\
  <ul>\
    <a href="http://www.wifishelter.com">wifishelter.com</a>\
  </li>\
  </ul>\
  ';
    templates.clickyspinny = '<h2>CLICKYSPINNY</h2>\
  <ul>\
  <li>\
    This site silly. Backbone.js, Coffeescript, venv, heroku deploy<br />\
    <a href="http://clickyspinny.com">clickyspinny.com</a><br />\
    <a href="https://github.com/clickyspinny/clickyspinny.com">github.com/clickyspinny/clickyspinny.com</a>\
  </li>\
  </ul>\
  ';
    templates.main_menu = '\
  <ul>\
  <a href="#fogfudge">\
  <li>\
    FOG FUDGE&trade;\
  </li>\
  </a>\
  <a href="#zoomzoom">\
  <li>\
    ZOOM ZOOM\
  </li>\
  <!--\
  <a href="#wifishelter">\
  <li>\
    WIFI SHELTER\
  </li>\
  </a> -->\
  <a href="#clickyspinny">\
  <li>\
    CLICKYSPINNY\
  </li>\
  </a>\
  </ul>\
  ';
    /* Router
    */
    ClickySpinner = Backbone.Router.extend({
      initialize: function(options) {
        this.mainView = new MainView;
        this.mainView.render().addContent();
        this.codeProjectsView = new CodeProjectsView;
        this.fogFudgeView = new FogFudgeView;
        this.zoomZoomView = new ZoomZoomView;
        this.clickySpinnyView = new ClickySpinnyView;
        return this.wifiShelterView = new WifiShelterView;
      },
      routes: {
        "code": "code",
        "fogfudge": "fogfudge",
        "zoomzoom": "zoomzoom",
        "clickyspinny": "clickyspinny",
        "wifishelter": "wifishelter",
        "": "code",
        "*actions": "defaultRoute"
      },
      code: function() {
        $("div#main-container").html(this.codeProjectsView.render().el);
        return this;
      },
      fogfudge: function() {
        $("div#main-container").html(this.fogFudgeView.render().el);
        return this;
      },
      zoomzoom: function() {
        $("div#main-container").html(this.zoomZoomView.render().el);
        return this;
      },
      clickyspinny: function() {
        $("div#main-container").html(this.clickySpinnyView.render().el);
        return this;
      },
      wifishelter: function() {
        $("div#main-container").html(this.wifiShelterView.render().el);
        return this;
      },
      defaultRoute: function(clicked) {
        console.log(this);
        $("div#main-container").html("");
        console.log(clicked);
        return this;
      }
    });
    /* Views
    */
    MainView = Backbone.View.extend({
      el: $("body"),
      template: templates.base,
      initialize: function() {
        this.benView = new BenView;
        return this.mainMenuView = new MainMenuView;
      },
      render: function() {
        $(this.el).html(this.template);
        return this;
      },
      addContent: function() {
        $("div#ben", this.el).html(this.benView.render().el);
        $("div#menu", this.el).html(this.mainMenuView.render().el);
        return this;
      }
    });
    BenView = Backbone.View.extend({
      tagName: 'div',
      className: 'face',
      template: templates.ben,
      events: {
        'hover': 'swapBens'
      },
      render: function() {
        $(this.el).html(this.template);
        return this;
      },
      swapBens: function() {
        $('img.floating-head', this.el).toggle();
        $('img.floating-head-hand', this.el).toggle();
        this.swapLog();
        return this;
      },
      swapLog: function() {
        return this;
      }
    });
    CodeProjectsView = Backbone.View.extend({
      tagName: 'div',
      className: 'projects',
      template: templates.code_projects,
      render: function() {
        $(this.el).html(this.template);
        return this;
      }
    });
    FogFudgeView = Backbone.View.extend({
      tagName: 'div',
      className: 'projects',
      template: templates.fogfudge,
      render: function() {
        $(this.el).html(this.template);
        return this;
      }
    });
    ClickySpinnyView = Backbone.View.extend({
      tagName: 'div',
      className: 'projects',
      template: templates.clickyspinny,
      render: function() {
        $(this.el).html(this.template);
        return this;
      }
    });
    ZoomZoomView = Backbone.View.extend({
      tagName: 'div',
      className: 'projects',
      template: templates.zoomzoom,
      render: function() {
        $(this.el).html(this.template);
        return this;
      }
    });
    WifiShelterView = Backbone.View.extend({
      tagName: 'div',
      className: 'projects',
      template: templates.wifishelter,
      render: function() {
        $(this.el).html(this.template);
        return this;
      }
    });
    MainMenuView = Backbone.View.extend({
      tagName: 'div',
      className: 'main-menu',
      template: templates.main_menu,
      render: function() {
        $(this.el).html(this.template);
        return this;
      }
    });
    this.clickySpinner = new ClickySpinner;
    return Backbone.history.start();
  });

}).call(this);
