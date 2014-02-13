App.GridLayoutView = Ember.View.extend({
  classNames: ['l-grid-wrap'],
  layout: Ember.Handlebars.compile('<div class="l-grid">{{yield}}</div>'),

  didInsertElement: function() {
    this._super();
    Ember.$(window).on('resize', Ember.$.proxy(this.debouncedResize, this));
    Ember.run.next(this, this.resize);
  },

  willDestroy: function() {
    Ember.$(window).off('resize', this.debouncedResize);
    this._super();
  },

  debouncedResize: function() {
    Ember.run.debounce(this, this.resize, 100);
  },

  resize: function() {
    var $item           = this.$('.js-grid-item');
    var itemCount       = Math.floor(this.$().width() / $item.outerWidth());
    var $grid           = this.$('.l-grid');
    var itemWidth       = $item.outerWidth();
    var innerChildWidth = $item.children(":first").outerWidth();
    var padding         = itemWidth - innerChildWidth;
    var newWidth        = itemCount * itemWidth + itemCount * 5;

    if(itemCount <= $item.length) {
      $item.attr('style', '');
      this.$('.js-grid-item:nth-of-type(' + itemCount + 'n)').css('padding-right', '0');
      $grid.width(newWidth - padding);
    } else {
      $item.css('padding-right', '');
      $grid.css('width', '');
    }
  }
});
