// For more information see: http://emberjs.com/guides/routing/

Settings.Router.map(function() {
  this.resource('settings', function() {
    this.route('account', { path: '/'} );
    this.route('address');
    this.route('sync');
  });
});
