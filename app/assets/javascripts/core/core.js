//= require_self
//= require ./models/addressable
//= require_tree ./models

Core = Ember.Namespace.create({ name: "Core" });

Core.registerModels = function(app){
  var models = Object.keys(this),
      modelName,
      model;

  for(var i = 0; i< models.length;i++){
    modelName = models[i];
    model= this[modelName];

    if (this.hasOwnProperty(modelName) && modelName != 'registerModels'){
       app[modelName] = model;
    }
  }
};
