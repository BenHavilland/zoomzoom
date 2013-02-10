(function() {

  $(function() {
    var BenView, MainView, ProjectsView, mainView, templates;
    templates = {};
    templates.base = '<div id="content"></div>';
    templates.ben = '\
  <a class="fork-me" href="https://github.com/clickyspinny">\
    <img style="position: absolute; top: 0; left: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_left_red_aa0000.png" alt="Fork me on GitHub">\
  </a>\
  <span class="floating-head">\
    <img src="static/img/floating_head_ben_crop_nohand.png" class="floating-head" />\
    <img src="static/img/floating_head_ben_crop.png" class="floating-head-hand" />\
  </span>\
  ';
    templates.projects = '<h2>Projects</h2>\
  <li>\
    Fog Fudge: Mezzanine, Cartridge, venv, heroku deploy<br />\
    <a href="http://fogfudge.heroku.com">fogfudge.com</a><br />\
    <a href="https://github.com/clickyspinny/fogfudge">github.com/clickyspinny/fogfudge</a>\
  </li>\
  <li>\
    Zoom Zoom: Backbone.js + Coffeescript app.<br />\
    <a href="http://clickyspinny.com/zoomzoom/">clickyspinny.com/zoomzoom/</a><br />\
    <a href="https://github.com/clickyspinny/zoomzoom">github.com/clickyspinny/zoomzoom</a>\
  </li>\
  <li>\
    clickyspinny: This site silly. Backbone.js + Coffeescript app, venv, heroku deploy<br />\
    <a href="http://clickyspinny.com">clickyspinny.com</a><br />\
    <a href="https://github.com/clickyspinny/clickyspinny.com">github.com/clickyspinny/clickyspinny.com</a>\
  </li>\
  ';
    /* Views
    */
    MainView = Backbone.View.extend({
      el: $("body"),
      template: templates.base,
      initialize: function() {
        this.benView = new BenView;
        return this.projectsView = new ProjectsView;
      },
      render: function() {
        $(this.el).html(this.template);
        return this;
      },
      addContent: function() {
        $("div#content", this.el).append(this.benView.render().el);
        $("div#content", this.el).append(this.projectsView.render().el);
        return this;
      }
    });
    BenView = Backbone.View.extend({
      tagName: 'div',
      className: 'face',
      template: templates.ben,
      events: {
        'hover': 'swapBens',
        'click': 'toggleLink'
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
      toggleLink: function() {
        $('a.fork-me', this.el).toggle();
        return this;
      },
      swapLog: function() {
        return this;
      }
    });
    ProjectsView = Backbone.View.extend({
      tagName: 'div',
      className: 'projects',
      template: templates.projects,
      render: function() {
        $(this.el).html(this.template);
        return this;
      }
    });
    mainView = new MainView;
    return mainView.render().addContent();
  });

}).call(this);
