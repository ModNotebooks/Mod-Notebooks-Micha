App.SettingsRoute = Ember.Route.extend({

  renderTemplate: function() {
    this.render('settings', {
      into: 'application',
      outlet: 'modal'
    });
  }

});
