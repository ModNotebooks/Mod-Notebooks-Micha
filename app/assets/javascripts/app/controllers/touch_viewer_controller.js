App.TouchViewerController = Ember.ArrayController.extend({
  sortProperties: ['index'],
  sortAscending: true,
  itemController: 'touchViewerPane',
  currentSlide: 0,

  notebook: function() {
    return this.get('content.firstObject').get('notebook');
  }.property('content'),

  actions: {
    swipeChange: function(index) {
      this.set('currentSlide', index);
    }
  }
});
