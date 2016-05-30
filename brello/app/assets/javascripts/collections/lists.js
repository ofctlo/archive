Brello.Collections.Lists = Backbone.Collection.extend({

  model: Brello.Models.List,
  comparator: 'position',

  url: function () {
    return "/boards/" + this.board.get('id') + "/lists";
  },
  
  move: function (id, newPos) {
    var list = this.get(id);
    this.each(function (currentList) {
      var listPos = currentList.get('position')
      // adjust for removing the list.
      if (listPos > list.get('position')) {
        listPos -= 1;
        currentList.set('position', listPos);
      }
      // make space at the new location.
      if (listPos >= newPos) {
        listPos += 1;
        currentList.set('position', listPos);
      }
      currentList.save();
    });
    // insert item at new location.
    list.set('position', newPos);
    list.save();
    this.sort();
  }
});
