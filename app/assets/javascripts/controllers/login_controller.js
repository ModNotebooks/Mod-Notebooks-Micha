App.LoginController = Ember.Controller.extend(Ember.SimpleAuth.LoginControllerMixin, {
  client_id: "3bb761a843711dad62fea243a4674843310f474fc8a757c714992cdd0f39d681",
  client_secret: "32dfc56b1e0d32a14bfa2ffcc97e5d7409485d1a268ede11f8fa83713092f539",

  tokenRequestOptions: function(identification, password, client_id, client_secret) {
    var json = {
        'grant_type':    'password',
        'username':      identification,
        'password':      password,
        'scope':         'public',
        'client_id':     client_id,
        'client_secret': client_secret
    };

    return { type: 'POST', data: json, dataType: 'json' }
  }
});
