Settings.SettingsAddressController = Ember.ObjectController.extend({
  actions: {
    save: function() {
      var _this = this;

      this.get('model').save();
    }
  }
});
