Settings.SettingsAddressController = Ember.ObjectController.extend({
  isLoading: false,
  actions: {
    save: function() {
      var _this = this;

      this.get('model').save().then(function() {
        _this.set('isLoading', false);
      })
    }
  }
});
