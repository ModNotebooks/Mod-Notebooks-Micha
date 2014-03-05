// For more information see: http://emberjs.com/guides/routing/

Settings.Router.map(function() {
  this.route('main.index');
  this.route('login');

  this.resource('settings', { path: '/' }, function() {
    this.route('account', { path: '/'} );
    this.route('address');
    this.route('sync');
  });
});
