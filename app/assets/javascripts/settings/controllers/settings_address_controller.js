Settings.SettingsAddressController = Ember.ObjectController.extend({
  isLoading: false,
  actions: {
    save: function() {
      var _this   = this,
          content = this.get('content');

      content.save().then(function() {
        _this.set('isLoading', false);
      }, function(errors) {
        _this.set('isLoading', false);
      });
    }
  }
});
