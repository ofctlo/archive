Brello.Models.Membership = Backbone.RelationalModel.extend({
  relations: [{
    type: Backbone.HasOne,
    key: 'member',
    relatedModel: 'Brello.Models.User'
  }]
});
