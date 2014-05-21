App.DigitizeCodeController = Ember.Controller.extend({
  needs: ['digitize', 'digitizeIndex'],

  code: null,
  name: null,
  error: null,
  completed: false,
  paperTypes: ["blank", "lined", "dotgrid"],

  actions: {
    advance: function() {
      var _this = this;
      this.canAdvance().then(function() {
        _this.set('error', null);
        _this.set('completed', true);
        _this.transitionToRoute('digitize.scan')
      }, function() {
        _this.set('error', 'Invalid code.');
      });
    },
  },

  canAdvance: function() {
    var code = this.get('code');

    return new Ember.RSVP.Promise(function(resolve, reject) {
      if (Ember.isEmpty(code)) {
        reject();
      } else {
        var data = { "notebook": { "notebook_identifier": code } };

        Ember.$.ajax({
          type: "POST",
          url: window.ENV.API_ENDPOINT + '/notebooks/exists.json',
          dataType: 'json',
          data: data,
          error: reject,
          success: resolve
        });
      }
    });
  },

  codeChanged: function() {
    this.set('error', null);
  }.observes('code'),

  paper: function() {
    var code, papers, paperCode;

    papers = this.get('paperTypes');
    code = this.get('code');

    if (!Ember.isEmpty(code)) {
      paperCode = parseInt(code.split("-")[1], 10);

      if (!!paperCode && paperCode <= papers.get('length')) {
        return papers[paperCode - 1];
      }
    }

    return "blank";
  }.property('code'),

  color: function() {
    var code, colorCode, setting;

    code = this.get('code');

    if (!Ember.isEmpty(code)) {
      colorCode = code.split("-")[0].toUpperCase();
      setting = this.get('settings').findBy('colorCode', colorCode) || this.get('settings').get('firstObject');
      return setting.get('color');
    }

    return "#a2a2a2";
  }.property('code'),

  style: function() {
    return "background-color: " + this.get('color') + ";";
  }.property('color')

});
