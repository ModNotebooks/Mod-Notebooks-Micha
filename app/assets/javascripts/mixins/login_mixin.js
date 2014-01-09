App.LoginMixin = Ember.Mixin.create({
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
