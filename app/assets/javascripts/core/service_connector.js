Core.ServiceConnector = {};

Core.ServiceConnector.setup = function(container, application, options) {

  this.serviceConnectionSucceeded = function(serviceData) {
    console.log('serviceConnectionSucceeded', serviceData);
  };

  this.serviceConnectionFailed = function(error) {
    console.log('serviceConnectionFailed', error);
  };

};
