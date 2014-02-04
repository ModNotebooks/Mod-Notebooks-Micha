Core.ServiceConnector = {};

Core.ServiceConnector.setup = function(container, application, options) {

  this.serviceConnectionSucceeded = function(data) {
    container.lookup('route:settings.sync').send('connectionSucceeded', data);
  };

  this.serviceConnectionFailed = function(error) {
    container.lookup('route:settings.sync').send('connectionFailed', error);
  };

};
