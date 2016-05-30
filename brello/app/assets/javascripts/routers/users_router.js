Brello.Routers.Users = Backbone.Router.extend({
  routes: {
    'users/:id': 'show'
  },
  
  show: function (id) {
    var user = Brello.Models.User.findOrCreate({ id: id });
    Brello.users.add(user);
    user.fetch();
    
    var profileView = new Brello.Views.UserShow({
      model: user
    });
    
    $('#content').html(profileView.render().$el);
  }
});