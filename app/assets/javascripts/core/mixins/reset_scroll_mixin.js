Core.ResetScrollMixin = Ember.Mixin.create({
  activate: function() {
    this._super();
    window.scrollTo(0,0);
  }
});
