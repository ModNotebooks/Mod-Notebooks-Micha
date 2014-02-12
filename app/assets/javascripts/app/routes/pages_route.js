App.PagesRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function(params) {
    var store = this.store;
    return Ember.RSVP.hash({
      notebook: store.find('notebook', params.notebook_id),
      pages: store.find('page', { notebook_id: params.notebook_id })
    });
  },

  setupController: function(controller, model) {
    controller.set('notebook', model.notebook);
    controller.set('content', model.pages);
  },
});

App.PagesShowRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function(params) {
    var pages = this.modelFor('pages').pages;

    return [
      pages.findBy('pageNumber', parseInt(params.left_page_number)),
      pages.findBy('pageNumber', parseInt(params.right_page_number))
    ]
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
