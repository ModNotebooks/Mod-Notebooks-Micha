// For more information see: http://emberjs.com/guides/routing/

App.Router.map(function() {
  this.route('demo');

  this.resource('login', function() {
    this.route('index', { path: '/' });
  });

  this.resource('signup', function() {
    this.route('index', { path: '/' });
  });

  this.resource('main', { path: '/' }, function() {
    this.resource('notebooks');
    this.resource('notebook', { path: '/notebooks/:notebook_id' });

    this.resource('viewer', { path: '/notebooks/:notebook_id/view' }, function() {
      this.route('pages', { path: ':left_page_index/:right_page_index' });
    });
  });

  this.resource('digitize', { path: '/digitize' }, function() {
    this.route('code');
    this.route('scan');
    this.route('address');
    this.route('confirmation');
  });
});
