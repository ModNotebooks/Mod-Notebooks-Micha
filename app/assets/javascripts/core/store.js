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

Core.PreferencesSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    address: { embedded: 'always' }
  }
});
