App.PagesRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function(params) {
    return this.store.find('notebook', params.notebook_id);
  }
});

App.PagesShowRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function(params) {
    console.log("PARMS", params);
  },

  setupController: function(controller, model) {
    console.log('MODEL', model);
  },

  serialize: function(model) {
    var page = model.get('pageNumber');

    if (page === 1) {
      return { left_page_number: 0, right_page_number: page }
    } else {
      return { left_page_number: page, right_page_number: page + 1 }
    }
  },
});
