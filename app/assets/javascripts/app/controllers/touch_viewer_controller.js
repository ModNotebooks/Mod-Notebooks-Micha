App.TouchViewerController = Ember.ArrayController.extend({
  needs: ['touchViewerPage'],
  sortProperties: ['index'],
  sortAscending: true,
  itemController: 'touchViewerPane',
  
  notebook: function() {
    return this.get('content.firstObject').get('notebook');
  }.property('content'),

  actions: {
    swipeChange: function(index) {
      this.set('currentSlide', index + 1);
    }
  }
});
