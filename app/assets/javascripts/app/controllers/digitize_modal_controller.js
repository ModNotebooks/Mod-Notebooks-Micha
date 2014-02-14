App.DigitizeModalController = Ember.ObjectController.extend({
  actions: {
    close: function() {
      return this.send('closeModal');
    },

    digitize: function() {
      this.send('closeModal');
      this.transitionTo('digitize');
    }
  }
});
