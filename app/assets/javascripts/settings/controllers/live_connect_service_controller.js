Settings.LiveConnectSyncServiceController = Settings.SyncServiceController.extend({
  actions: {
    connectionSucceeded: function(data) {
      var model = this.get('content');
      var service = model.get('service');

      console.log('DATA', data);

      service.setProperties({
        uid: data.uid,
        name: data.info.name,
        email: data.info.nickname || "",
        token: data.credentials.token,
        refreshToken: data.credentials.refresh_token,
        expiresAt: new Date(data.credentials.expires_at * 1000),
        meta: data.extra
      });

      this._super(data);
    }
  }
});
