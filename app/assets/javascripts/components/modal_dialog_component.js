App.ModalDialogComponent = Ember.Component.extend({
  actions: {
    close: function() {
      return this.sendAction();
    }
  },

  didInsertElement: function() {
    var element = this.get('element');

    // Ember.$('.l-app-content').addClass('blurred');
    var contentElement = Ember.$('.l-app-content').get(0);
    var filterProperty = Modernizr.testProp('webkitFilter') ? "webkitFilter" : Modernizr.prefixed('filter');

    var tween = new TWEEN.Tween({ blur: 0 })
      .to({ blur: 44 }, 2000)
      .easing( TWEEN.Easing.Quadratic.InOut )
      .onUpdate(function() {
        contentElement.style[filterProperty] = "blur(" + this.blur + "px)";
      })
      .start();

    var tween2 = new TWEEN.Tween({ opacity: 0 })
      .to({ opacity: 1 }, 2000)
      .easing( TWEEN.Easing.Quadratic.InOut )
      .onUpdate(function() {
        element.style.opacity = this.opacity;
      })
      .start();


    Ember.$(document.documentElement).addClass('no-scroll');
  },

  willDestroyElement: function() {
    // Ember.$('.l-app-content').removeClass('blurred');

    var contentElement = Ember.$('.l-app-content').get(0);
    var filterProperty = Modernizr.testProp('webkitFilter') ? "webkitFilter" : Modernizr.prefixed('filter');

    var tween = new TWEEN.Tween({ blur: 44 })
      .to({ blur: 0 }, 2000)
      .easing( TWEEN.Easing.Quadratic.InOut )
      .onUpdate(function() {
        contentElement.style[filterProperty] = "blur(" + this.blur + "px)";
      })
      .start();

    Ember.$(document.documentElement).removeClass('no-scroll');
  }
});
