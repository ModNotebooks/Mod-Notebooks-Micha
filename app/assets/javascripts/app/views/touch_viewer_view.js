App.TouchViewerView = Ember.View.extend({
  didInsertElement: function() {
    this.swipe = Swipe(this.$('.touchviewer__pages').get(0), {
      childSelector: '.touchviewer__pane',
      callback: this.swipeCallback.bind(this)
    });
  },

  swipeCallback: function(index, elem) {
    this.get('controller').send('swipeChange', index);
  },

  willDestroyElement: function() {
    this.swipe.kill();
  }
});
