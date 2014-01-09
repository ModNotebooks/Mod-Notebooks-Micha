// http://emberjs.com/guides/models/using-the-store/

App.Store = DS.Store.extend({
  // Override the default adapter with the `DS.ActiveModelAdapter` which
  // is built to work nicely with the ActiveModel::Serializers gem.
  adapter: DS.ActiveModelAdapter.extend({
    host: 'http://api.lvh.me:3000',

    // http://www.g9labs.com/2013/12/27/ember-data-rails-cors-and-you/
    buildURL: function(record, suffix) {
      return this._super(record, suffix) + ".json";
    }
  })
});
