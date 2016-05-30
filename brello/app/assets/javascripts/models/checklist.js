Brello.Models.Checklist = Backbone.RelationalModel.extend({
  relations: [{
    type: Backbone.HasMany,
    key: 'checklistItems',
    relatedModel: 'Brello.Models.ChecklistItem',
    collectionType: 'Brello.Collections.ChecklistItems',
    keySource: 'checklist_items',
    reverseRelation: {
      key: 'checklist',
      includeInJSON: true
    }
  }]
});
