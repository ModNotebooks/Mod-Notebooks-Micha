App.ModalDialogComponent = Ember.Component.extend({
  classNames: "modal",

  actions: {
    close: function() {
      this.animateOut().then(this.sendAction.bind(this));
    }
  },

  eventManager: Ember.Object.create({
    click: function(evt, view) {
      if (view.$(evt.target).hasClass('modal__content')) {
        view.send('close');
      }
    }
  }),

  didInsertElement: function() {
    var _this = this;
    Ember.$(document.documentElement).addClass('no-scroll');
    Ember.$('.l-app-content').addClass('modal-open');

    Ember.run.later(function() {
      _this.$().addClass('is-visible');
    }, 100);
  },

  animateOut: function() {
    var _this = this;

    return new Ember.RSVP.Promise(function(resolve) {
      _this.$().removeClass('is-visible').one(App.utils.transitionEnd, function() {
        Ember.$('.l-app-content').removeClass('modal-open');
        resolve();
      });
    });
  },

  willDestroyElement: function() {
    Ember.$(document.documentElement).removeClass('no-scroll');
  }
});
