(function() {

  $(function() {
    var ToolBar, ToolBarView;
    $('body').fadeIn();
    ToolBarView = Backbone.View.extend({
      tagName: "div",
      className: "toolbar",
      template: "<p>This is just a local template doc  that will be \    changed in the near future.<p/> \    <p>Once we define out models we will add list items here like below.</p>    <h3>Cars</h3>    <ul>      <li>2001 Volvo V70 T5</li>      <li>1991 BMW 325ic</li>      <li>1976 Ford F350</li>    </ul>    <h3>Motorcycles</h3>    <ul>      <li>1980 Honda CB750</li>      <li>1980 Honda CM400T</li>      <li>1982 Honda CM250C</li>    </ul>    ",
      initialize: function() {
        return $('body').append(this.render().el);
      },
      render: function() {
        $(this.el).html(this.template);
        return this;
      }
    });
    return ToolBar = new ToolBarView;
  });

}).call(this);
