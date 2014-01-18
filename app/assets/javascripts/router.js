// For more information see: http://emberjs.com/guides/routing/

App.Router.map(function() {
  this.route('login');
  this.route('signup');
  this.resource('notebooks');
  this.resource('notebook', { path: '/notebooks/:notebook_id' });
  this.resource('notebook.view', { path: '/notebooks/:notebook_id/view' });
});
