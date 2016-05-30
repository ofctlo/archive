Brello.Models.List = Backbone.RelationalModel.extend({
  relations: [{
    type: Backbone.HasMany,
    key: 'cards',
    relatedModel: 'Brello.Models.Card',
    collectionType: 'Brello.Collections.Cards',
    reverseRelation: {
      key: 'list',
      includeInJSON: 'id'
    }
  }],
  
  destroyCard: function (id) {
    // TODO: should we worry here about not finding the card?
    var removedCard = Brello.Models.Card.findOrCreate({ id: id });
    var emptyPos = removedCard.get('position');
    removedCard.destroy();
    // this.get('cards').remove(id);
    this.get('cards').each(function(card) {
      var cardPos = card.get('position');
      
      if (cardPos > emptyPos) {
        card.set('position', cardPos - 1);
        card.save();
      }
    });
  },
  
  removeCard: function (id) {
    // TODO: should we worry here about not finding the card?
    var removedCard = Brello.Models.Card.findOrCreate({ id: id });
    var emptyPos = removedCard.get('position');
    var cards = this.get('cards');
    cards.remove(id);
    // Adjust positions downward for cards below (higher pos) the removed card.
    cards.each(function(card) {
      var cardPos = card.get('position');
      
      if (cardPos > emptyPos) {
        card.set('position', cardPos - 1);
        card.save();
      }
    });
  },
  
  insertCard: function (card, insertPos) {    
    this.get('cards').each(function (currentCard) {
      var cardPos = currentCard.get('position');
      // Increment position of cards below where the card is to be inserted.
      if (cardPos >= insertPos) {
        currentCard.set('position', cardPos + 1);
      }
    });
    card.set({ position: insertPos, list_id: this.get('id') });
    this.get('cards').add(card);
    
    card.save();
    // Sorts by position. This should be redundant, and would
    // like to remove.
    // Since there were some problems, need to do some debugging first.
    this.get('cards').sort();
  }
});
