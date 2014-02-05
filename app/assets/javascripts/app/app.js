//= require_tree ./mixins
// require_tree ./models
//= require_tree ./controllers
//= require_tree ./views
//= require_tree ./components
//= require_tree ./templates
//= require ./router
//= require_tree ./routes
//= require_self

// http://emberjs.com/guides/models/using-the-store/

App.ApplicationAdapter = Core.ApplicationAdapter;
App.NotebookSerializer = Core.NotebookSerializer;
App.PreferencesSerializer = Core.PreferencesSerializer;
App.AddressSerializer  = Core.AddressSerializer;
App.UserSerializer = Core.UserSerializer;
App.SpinButtonComponent = Core.SpinButtonComponent;
