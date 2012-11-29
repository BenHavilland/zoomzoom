(function() {

  $(function() {
    var BenView, MainView, mainView, templates;
    templates = {};
    templates.base = '<div id="content"></div>';
    templates.ben = '\
  <a class="fork-me" href="https://github.com/clickyspinny">\
    <img style="position: absolute; top: 0; left: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_left_red_aa0000.png" alt="Fork me on GitHub">\
  </a>\
  <a href="https://github.com/clickyspinny">\
    <img src="static/img/floating_head_ben_crop_nohand.png" class="floating-head" />\
    <img src="static/img/floating_head_ben_crop.png" class="floating-head-hand" />\
  </a>\
  ';
    BenView = Backbone.View.extend({
      tagName: 'div',
      className: 'face',
      template: templates.ben,
      events: {
        'hover': 'swapHeads'
      },
      render: function() {
        $(this.el).html(this.template);
        return this;
      },
      swapHeads: function() {
        $('img.floating-head', this.el).toggle();
        $('img.floating-head-hand', this.el).toggle();
        $('a.fork-me', this.el).toggle();
        this.swapLog();
        return this;
      },
      swapLog: function() {
        return this;
      }
    });
    MainView = Backbone.View.extend({
      el: $("body"),
      template: templates.base,
      initialize: function() {
        return this.benView = new BenView;
      },
      render: function() {
        $(this.el).html(this.template);
        return this;
      },
      addContent: function() {
        $("div#content", this.el).append(this.benView.render().el);
        return this;
      }
    });
    mainView = new MainView;
    return mainView.render().addContent();
  });

}).call(this);
