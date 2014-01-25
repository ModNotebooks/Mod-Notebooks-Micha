// http://emberjs.com/guides/models/using-the-store/

App.ApplicationAdapter = DS.ActiveModelAdapter.extend({
  host: window.ENV.API_ENDPOINT,

  // http://www.g9labs.com/2013/12/27/ember-data-rails-cors-and-you/
  buildURL: function(record, suffix) {
    return this._super(record, suffix) + ".json";
  }
});

App.NotebookSerializer = DS.ActiveModelSerializer.extend({
  normalizeHash: {
    notebooks: function(hash) {
      hash.currState = hash.current_state;
      delete hash.current_state;
      return hash;
    }
  }
});

App.UserSerializer = DS.ActiveModelSerializer.extend({
  serialize: function(record, options) {
    var json = this._super.apply(this, arguments);

    json.address_attributes = json.address;
    delete json.address;

    return json;
  },

  extractSingle: function(store, type, payload, id, requestType) {
    console.log(payload);

    var address   = payload.user.address,
        addressId = [address.id];

    payload.addresses = [address];
    payload.user.address = addressId;

    return this._super.apply(this, arguments);
  }
});

App.AddressSerialize = DS.ActiveModelSerializer.extend({
  serializePolymorphicType: function(record, json, relationship) {
    console.log('HERE', record, json, relationship);
     var key = relationship.key,
         belongsTo = get(record, key);
     key = this.keyForAttribute ? this.keyForAttribute(key) : key;
     json[key + "_type"] = belongsTo.constructor.typeKey;
   }
});
