App.PagesRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function(params) {
    return this.store.find('notebook', params.notebook_id);
  },

  setupController: function(controller, model) {
    controller.set('notebook', model);
    controller.set('content', model.get('pages'));
  }
});

// App.PagesIndexRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
//   redirect: function() {
//     var notebook = this.modelFor('pages');
//     var page     = this.controllerFor('pages').get('arrangedContent').get('firstObject');
//     this.transitionTo('pages.show', notebook, page);
//   }
// });

App.PagesShowRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function(params) {
    var pages = this.modelFor('pages').get('pages');

    return new Ember.RSVP.Promise(function(resolve, reject) {
      pages.then(function(pages) {
        resolve([
          pages.findBy('pageNumber', parseInt(params.left_page_number)),
          pages.findBy('pageNumber', parseInt(params.right_page_number))
        ]);
      }, function(err) {
        reject(err);
      });
    });
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
