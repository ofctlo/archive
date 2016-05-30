Brello.Models.Card = Backbone.RelationalModel.extend({
  relations: [{
    type: Backbone.HasMany,
    key: 'checklists',
    relatedModel: 'Brello.Models.Checklist',
    collectionType: 'Brello.Collections.Checklists',
    reverseRelation: {
      key: 'card',
      includeInJSON: true
    }
  }]
});
