// http://emberjs.com/guides/models/using-the-store/

Core.ApplicationAdapter = DS.ActiveModelAdapter.extend({
  host: window.ENV.API_ENDPOINT,

  // http://www.g9labs.com/2013/12/27/ember-data-rails-cors-and-you/
  buildURL: function(record, suffix) {
    return this._super(record, suffix) + ".json";
  }
});

Core.NotebookSerializer = DS.ActiveModelSerializer.extend({
  normalizeHash: {
    notebooks: function(hash) {
      hash.currState = hash.current_state;
      delete hash.current_state;
      return hash;
    }
  }
});

Core.PreferencesSerializer = DS.ActiveModelSerializer.extend({
  normalizeId: function(hash) {
    this._super();
    hash.id = 'me';
  },

  serializeBelongsTo: function(record, json, relationship) {
    var key = relationship.key;

    if (key === "address") {
      json['address_attributes'] = record.get('address').toJSON();
    }
  }
});

Core.AddressSerializer = DS.ActiveModelSerializer.extend({
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

Core.UserSerializer = DS.ActiveModelSerializer.extend({
  normalizeId: function(hash) {
    this._super();
    hash.id = 'me';
  }
});
