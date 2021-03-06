Ember.Application.initializer({
  name: 'nprogress',
  initialize: function(container, application) {
    application.ApplicationRoute = (application.ApplicationRoute || Ember.Route).extend({
      actions: {
        loading: function() {
          NProgress.start();
          this.router.one('didTransition', function() {
            NProgress.done();
          });
        },

        error: function() {
          NProgress.done();
          return this._super.apply(this, Array.prototype.slice.apply(arguments));
        }
      }
    });
  }
});
