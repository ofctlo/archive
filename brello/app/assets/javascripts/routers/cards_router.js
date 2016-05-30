Brello.Routers.Cards = Backbone.Router.extend({
  routes: {
    "cards/:id": "show"
  },
  
  show: function (id) {
    var card = Brello.Models.Card.findOrCreate({ id: id });
    card.fetch({
      success: function (card) {
        var showView = new Brello.Views.CardShow({
          model: card
        });
        // since the card view appears over the previous view,
        // it doesn't really matter where in the DOM we place it.
        $('#content').append(showView.render().$el);
      }
    });
  }
});
