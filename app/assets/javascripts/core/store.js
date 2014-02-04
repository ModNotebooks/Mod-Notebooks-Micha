// http://emberjs.com/guides/models/using-the-store/

Core.ApplicationAdapter = DS.ActiveModelAdapter.extend({
  host: window.ENV.API_ENDPOINT,

  // http://www.g9labs.com/2013/12/27/ember-data-rails-cors-and-you/
  buildURL: function(record, suffix) {
    return this._super(record, suffix) + ".json";
  }
});

Core.ApplicationSerializer = DS.ActiveModelSerializer.extend({
  serializeAttribute: function(record, json, key, attribute) {
    var value = Ember.get(record, key);

    if (!Ember.isEmpty(value)) {
      return this._super(record, json, key, attribute);
    }
  }
});

Core.NotebookSerializer = Core.ApplicationSerializer.extend({
  normalizeHash: {
    notebooks: function(hash) {
      hash.currState = hash.current_state;
      delete hash.current_state;
      return hash;
    }
  }
});

Core.PreferencesSerializer = Core.ApplicationSerializer.extend({
  normalizeId: function(hash) {
    this._super();
    hash.id = 'me';
  }
});

Core.AddressSerializer = Core.ApplicationSerializer.extend({
  normalizeId: function(hash) {
    this._super();
    hash.id = 'me';
  },

  normalize: function(type, hash, prop) {
    var hash = this._super(type, hash, prop);
    hash.addressable.id = 'me';
    return hash;
  }
});

Core.UserSerializer = Core.ApplicationSerializer.extend({
  normalizeId: function(hash) {
    this._super();
    hash.id = 'me';
  }
});

Core.ServiceSerializer = Core.ApplicationSerializer.extend({
  normalize: function(type, hash, prop) {
    var hash = this._super(type, hash, prop);
    hash.user = 'me';
    return hash;
  }
});
