Brello.Collections.Cards = Backbone.Collection.extend({

  model: Brello.Models.Card,
  
  comparator: 'position',
  
  url: function () {
    return "/lists/" + this.list.get('id') + "/cards";
  },
  
  // Close up gaps after removing a card.
  resetPositions: function () {
    this.each(function(card, i) {
      card.set('position', i);
    });
  },
  
  // Open a gap to insert a new card.
  openPosition: function (position) {
    this.each(function(card, i) {
      if (i >= position) {
        var newPosition = card.get('position') + 1;
        card.set('position', newPosition);
      }
    });
  }
});
