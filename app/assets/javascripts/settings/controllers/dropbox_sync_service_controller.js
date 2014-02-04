Settings.DropboxSyncServiceController = Settings.SyncServiceController.extend({

  actions: {
    connectionSucceeded: function(data) {
      alert('DROPBOX SUCCESS!');
    },

    connectionFailed: function(data) {
      alert('DROPBOX FAILED ;(');
    }
  }

});
