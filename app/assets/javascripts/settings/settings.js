//= require ./controllers/sync_service_controller
//= require_tree ./controllers
//= require_tree ./views
//= require_tree ./templates
//= require ./router
//= require_tree ./routes
//= require_self

Settings.ApplicationAdapter = Core.ApplicationAdapter;
Settings.NotebookSerializer = Core.NotebookSerializer;
Settings.PreferencesSerializer  = Core.PreferencesSerializer;
Settings.AddressSerializer  = Core.AddressSerializer;
Settings.UserSerializer = Core.UserSerializer;
Settings.ServiceSerializer = Core.ServiceSerializer;
Settings.SpinButtonComponent = Core.SpinButtonComponent;
Settings.ModalDialogComponent = Core.ModalDialogComponent;
