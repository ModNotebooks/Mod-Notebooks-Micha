App.ViewerController = Ember.ArrayController.extend({
  needs: ['viewerPages'],

  notebook: function() {
    return this.get('content.firstObject').get('notebook');
  }.property('content'),

  actions: {
    next: function() {
      this.get('controllers.viewerPages').send('next');
    },

    previous: function() {
      this.get('controllers.viewerPages').send('previous');
    }
  }
});
