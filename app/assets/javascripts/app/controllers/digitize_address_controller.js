App.DigitizeAddressController = Ember.ObjectController.extend({
  needs: ['digitize', 'digitizeScan'],

  completed: false,
  handleMethod: null,
  isLoading: false,

  actions: {
    advance: function() {
      var _this   = this,
          content = this.get('content');

      content.save().then(function() {
        _this.set('isLoading', false);
        _this.set('hasCompleted', true);
        _this.transitionToRoute('digitize.confirmation');
      }, function(errors) {
        _this.set('isLoading', false);
      });
    },
  }
});
