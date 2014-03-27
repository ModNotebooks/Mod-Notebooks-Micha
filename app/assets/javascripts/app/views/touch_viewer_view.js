App.TouchViewerView = Ember.View.extend({
  menuHidden: false,

  didInsertElement: function() {
    this.swipe = Swipe(this.$('.touchviewer__pages').get(0), {
      childSelector: '.touchviewer__pane',
      callback: this.swipeCallback.bind(this),
      speed: 400,
      disableScroll: true
    });
  },

  swipeCallback: function(index, elem) {
    this.get('controller').send('swipeChange', index);
  },

  actions: {
    next: function() {
      this.swipe.next();
    },

    previous: function() {
      this.swipe.prev();
    }
  },

  willDestroyElement: function() {
    this.swipe.kill();
  }
});
