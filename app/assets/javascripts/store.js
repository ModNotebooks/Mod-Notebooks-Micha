// http://emberjs.com/guides/models/using-the-store/

App.ApplicationAdapter = DS.ActiveModelAdapter.extend({
  host: 'http://api.lvh.me:3000',

  // http://www.g9labs.com/2013/12/27/ember-data-rails-cors-and-you/
  buildURL: function(record, suffix) {
    return this._super(record, suffix) + ".json";
  }
});

App.MeScopedAdapter = App.ApplicationAdapter.extend({
  host: 'http://api.lvh.me:3000/me'
});


App.Store = DS.Store.extend({});

App.NotebookAdapter = App.MeScopedAdapter;
App.PageAdapter     = App.MeScopedAdapter
