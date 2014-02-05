Settings.SettingsAccountController = Ember.ObjectController.extend({
  isLoading: false,

  actions: {
    save: function() {
      var _this = this,
          model = this.get('model');

      model.save().then(function() {
        _this.set('isLoading', false);
      }, function(error) {
        _this.set('isLoading', false);
      });
    }
  }
});
