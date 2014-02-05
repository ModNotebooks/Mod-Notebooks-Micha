App.NotebookRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function(params) {
    var store = this.store;

    return new Ember.RSVP.Promise(function(resolve, reject) {
      store.find('notebook', params.notebook_id).then(function(notebook) {
        notebook.get('pages').then(function(pages) {
          resolve(notebook);
        }, function(err) {
          reject(err);
        })
      }, function(err) {
        reject(err);
      })
    });
  },

  renderTemplate: function() {
    this.render('notebook', {
      into: 'application',
      outlet: 'content'
    })
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('pages', model.get('pages'));
  }
});
