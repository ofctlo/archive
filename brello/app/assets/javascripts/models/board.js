Brello.Models.Board = Backbone.RelationalModel.extend({
  relations: [
    {
      type: Backbone.HasOne,
      key: 'user',
      relatedModel: 'Brello.Models.User'
    },
    {
      type: Backbone.HasMany,
      key: 'lists',
      relatedModel: 'Brello.Models.List',
      collectionType: 'Brello.Collections.Lists',
      reverseRelation: {
        key: 'board',
        includeInJSON: 'id'
      }
    },
    {
      type: Backbone.HasMany,
      key: 'memberships',
      relatedModel: 'Brello.Models.Membership',
      collectionType: 'Brello.Collections.Memberships',
    }
  ],
  
  destroyList: function (id) {
    var removedList = Brello.Models.List.findOrCreate({ id: id });
    var emptyPosition = removedList.get('position');
    removedList.destroy();
    
    this.get('lists').each(function (list) {
      var oldPosition = list.get('position');
      
      if (oldPosition > emptyPosition) {
        list.set('position', oldPosition - 1);
        list.save();
      }
    });    
  }
});