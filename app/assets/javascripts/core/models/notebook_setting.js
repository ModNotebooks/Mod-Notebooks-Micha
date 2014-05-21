Core.NotebookSetting = (function() {

  var attr = DS.attr;

  return DS.Model.extend({
    name:      attr('string'),
    color:     attr('string'),
    colorCode: attr('string')
  });

}());
