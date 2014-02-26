Core.ModalDialogComponent = Ember.Component.extend({
  background: "under",

  actions: {
    close: function() {
      var _this = this;
      this.animateOut().then(function() {
        _this.sendAction('close');
      });
    },

    doAction: function(action) {
      var _this = this;
      this.animateOut().then(function() {
        _this.sendAction(action);
      });
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
    this._super();

    var _this = this;
    this.sendAction('change', true);

    Ember.run.later(function() {
      _this.$().addClass('is-visible');
    }, 100);
  },

  animateOut: function() {
    var _this = this;

    return new Ember.RSVP.Promise(function(resolve) {
      _this.sendAction('change', false);
      _this.$().removeClass('is-visible').one(Core.utils.transitionEnd, function() {
        resolve();
      });
    });
  },

  willDestroyElement: function() {
    Ember.$(document.documentElement).removeClass('no-scroll');
    this._super();
  },

  backgroundClass: function() {
    return this.get('background') === "over" ? "modal-background--over" : "modal-background";
  }.property('background')
});
