App.SettingsController = Ember.ObjectController.extend({

  tabs: [
    Ember.Object.create({ name: "Account", tabId: "accountSettings", iconClass: "i-settings-account", active: true }),
    Ember.Object.create({ name: "Shipping Address", tabId: "addressSettings", iconClass: "i-settings-address" }),
    Ember.Object.create({ name: "Sync", tabId: "syncSettings", iconClass: "i-settings-sync" })
  ],

  actions: {
    close: function() {
      return this.send('closeModal');
    },

    setActiveTab: function(tabId) {
      this.get('tabs').setEach('active', false);
      this.get('tabs').findBy('tabId', tabId).set('active', true);
    }
  }
});
