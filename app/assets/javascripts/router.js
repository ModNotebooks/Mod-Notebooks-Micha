// For more information see: http://emberjs.com/guides/routing/

App.Router.map(function() {
  this.route('login');
  this.route('signup');
  this.resource('notebooks.index', { path: '/' } );
});
