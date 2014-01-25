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

App.UserSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  serialize: function(record, options) {
    var json = this._super.apply(this, arguments);

    json.address_attributes = json.address;
    delete json.address;

    return json;
  }
});
