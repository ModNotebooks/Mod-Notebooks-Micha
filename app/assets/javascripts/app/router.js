// For more information see: http://emberjs.com/guides/routing/

App.Router.map(function() {
  this.route('login');
  this.route('signup');
  this.route('password_reset');

  this.resource('notebooks');
  this.resource('notebook', { path: '/notebooks/:notebook_id' });

  this.resource('viewer', { path: '/notebooks/:notebook_id/view' }, function() {
    this.route('pages', { path: ':left_page_index/:right_page_index' });
  });

  this.resource('digitize', { path: '/digitize' }, function() {
    this.route('code');
    this.route('scan');
    this.route('address');
    this.route('confirmation');
  });
});
