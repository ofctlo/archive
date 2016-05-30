Brello.Collections.Checklists = Backbone.Collection.extend({

  model: Brello.Models.Checklist,
  
  url: function () {
    return '/cards/' + this.card.get('id') + '/checklists'
  }
});
