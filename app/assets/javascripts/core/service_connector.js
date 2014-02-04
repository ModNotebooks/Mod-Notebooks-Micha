Core.ServiceConnector = {};

Core.ServiceConnector.setup = function(container, application, options) {

  this.serviceConnectionSucceeded = function(data) {
    var provider = data.provider;
    controller = container.lookup('controller:syncService');

    console.log(data);

    if (provider === "dropbox") {
      var name = 'controller:' + provider + 'SyncService';
      controller = container.lookup(name);
    }

    controller.send('connectionSucceeded', data);
  };

  this.serviceConnectionFailed = function(error) {
    var provider = data.provider;
    controller = container.lookup('controller:syncService');

    if (provider === "dropbox") {
      var name = 'controller:' + provider + 'SyncService';
      container.lookup(name);
    }

    console.log(controller);

    controller.send('connectionFailed', data);
  };

};
