Settings.DropboxSyncServiceController = Settings.SyncServiceController.extend({
  actions: {
    connectionSucceeded: function(data) {
      var model = this.get('content');

      console.log("CONTROLLER", this);

      var service = model.get('service');

      service.setProperties({
        uid: data.uid,
        name: data.info.name,
        email: data.info.email,
        token: data.credentials.token,
        secret: data.credentials.secret,
        meta: data.raw_info
      });

      service.save().then(function() {
        alert("CONNECTED!");
      }, function(error) {
        alert("FAILED!");
      });
    },

    connectionFailed: function(data) {
      alert('DROPBOX FAILED ;(');
    }
  }

});
