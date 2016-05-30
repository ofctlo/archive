Brello.Collections.Memberships = Backbone.Collection.extend({

  model: Brello.Models.Membership,

  url: function () {
    return '/memberships';
  }
});
