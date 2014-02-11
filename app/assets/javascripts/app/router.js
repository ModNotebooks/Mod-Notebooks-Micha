// For more information see: http://emberjs.com/guides/routing/

App.Router.map(function() {
  this.route('login');
  this.route('signup');
  this.route('password_reset');

  this.resource('notebooks');
  this.resource('notebook', { path: '/notebooks/:notebook_id' });
  this.resource('pages', { path: '/notebooks/:notebook_id/pages' }, function() {
    this.route('show', { path: ':left_page_number/:right_page_number' });
  });
});
