Brello.Views.CardsIndex = Backbone.View.extend({
  // className: 'card-sortable cards',
  template: JST['cards/index'],
  
  events: {
    'click .card_link': 'cardShow',
    'click .new_card_link': 'displayNewCardForm',
    // 'mouseover .new_card_link': 'displayNewCardForm',
    // 'mouseout .new_card_form': 'dismissNewCardForm',
    
    'submit .new_card_form': 'processNewCard',
    'keypress .new_card_form': 'processNewCard',
    'click .dismiss_new_card_form': 'dismissNewCardForm',
    'click .card-delete': 'deleteCard',
  },
  
  initialize: function () {
    this.listenTo(this.collection, "add remove change", this.render);
  },
  
  render: function () {
    // Before we re-render, see if there was an active new card form.
    // If so we should show the active new card form immediately.
    var formActive = (this.$el.find('.new_card_form').length > 0 &&
                       this.$el.find('.new_card_form').css('display') === 'block')

    this.$el.html(this.template({ cards: this.collection }));    
    this.setupSortable();
    if (formActive) this.displayNewCardForm();
    
    return this;
  },
  
  setupSortable: function () {
    var that = this;
    
    this.$el.find('.card-sortable').disableSelection().sortable({
      tolerance: 'pointer',
      items: '.card_link',
      connectWith: '.card-sortable',
      placeholder: 'card-dropzone',
      revert: 200,
      
      start: function (event, ui) {
        ui.placeholder.height(ui.item.height());
        ui.placeholder.width(ui.item.width());
        ui.item.toggleClass('card_link dragging_card');
      },
      
      // beforeStop: that.moveCard
      stop: that.moveCard
    });
  },
  
  cardShow: function (event) {
    // debugger
    // TODO: better this up: sometimes the span intercepts the event
    // so that event.target doesn't have data-id.
    var id = $(event.target).data('id') || 
             $(event.target).parents('.card_link').data('id');
             
    var card = Brello.Models.Card.findOrCreate({ id: id });
    card.fetch()

    Backbone.history.navigate('#/cards/' + id, true);
  },
  
  moveCard: function (event, ui) {
    var card = Brello.Models.Card.findOrCreate({ id: ui.item.data('id') });
    var oldCards = card.collection;
    var newList = Brello.Models.List.findOrCreate({
      // Have to get the id for the new list from the position
      // in the DOM of the dropped card. Which list is it a child of?
      id: ui.item.parents('.list').data('id')
    });
    var newCards = newList.get('cards');
    var position = ui.item.index();
    
    oldCards.remove(card);
    oldCards.resetPositions();
    newCards.openPosition(position);
    
    card.set({ position: position, list_id: newList.get('id') });
    newCards.add(card, { wait: true });
    card.save();
  },
  
  displayNewCardForm: function (event) {
    if (event) event.preventDefault();
    
    this.$el.find('.new_card_link').css('display', 'none');
    this.$el.find('.new_card_form').css('display', 'block');
    this.$el.find('textarea').focus();
  },
  
  dismissNewCardForm: function (event) {
    // sometimes we call this from elsewhere to dismiss the form.
    // then there is no associated event.
    if (event) event.preventDefault();
    
    this.$el.find('.new_card_form').css('display', 'none');
    this.$el.find('.new_card_link').css('display', 'block');
  },
  
  processNewCard: function (event) {
    // keypress 13 is return/enter
    if (event.type === 'keypress' && event.charCode !== 13) return;
    
    event.preventDefault();

    var cardData = $(event.target).serializeJSON().card;
    var card = new Brello.Models.Card(cardData);
    if (card.get('title').length < 1) return;
    
    this.collection.add(card, { wait: true });
    
    card.save();
  },
  
  deleteCard: function (event) {
    var that = this;
    
    event.preventDefault();
    event.stopPropagation();
    var id = $(event.target).data('id');
    // var card = Brello.Models.Card.findOrCreate({ id: id });
    var listId = $(event.target).parents('.list').data('id');
    var list = Brello.Models.List.findOrCreate({ id: listId });
    $(event.target).parents('.card_link').fadeOut(300, function () {
      // don't forget to adjust the positioning
      list.destroyCard(id);
    });
  },
});