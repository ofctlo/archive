Brello.Views.ListShow = Backbone.View.extend({
  template: JST['lists/show'],
    
  className: 'list',
  
  events: {
    'click .list_title': 'displayListTitleEditForm',
    // 'click .dismiss_special_form': 'dismissSpecialForm',
    'submit #list_title_form': 'processListTitleForm',
    'keypress #list_title_form': 'processListTitleForm'
  },
  
  initialize: function () {
    this.listenTo(this.model, "change", this.render);
    // this.listenTo(this.collection, "change add remove sort", this.render);
    
    this.$el.attr('data-id', this.model.get('id'));
    this.$el.attr('data-pos', this.model.get('position'));
  },
  
  render: function () {
    this.$el.html(this.template({ list: this.model }));    
    
    this.$el.find('.cards_index').html(new Brello.Views.CardsIndex({
      collection: this.model.get('cards')
    }).render().$el);
    
    return this;
  },
  
  displayListTitleEditForm: function (event) {
    // on list drag a noclick class is placed on the list's title
    // to prevent the form from appearing upon release of the mouse.
    // This removes the class so after being repositioned it can be
    // clicked again as normal.
    if ($(event.target).hasClass('noclick')) {
      $(event.target).removeClass('noclick');
      return;
    }
    
    event.stopPropagation();
    
    $('.special_form').remove();
    
    var form = $(JST['shared_text_form']({
      submitAs: 'list[title]',
      placeholderText: $(event.target).html(),
      formName: 'list_title_form'
    }));
    
    this.$el.append(form);
    
    form.css({
      top: event.clientY + "px",
      left: event.clientX + "px"
    });
    
    form.find('textarea').focus().select();
  },
  
  dismissSpecialForm: function (event) {
    event.preventDefault();
    event.stopPropagation();
    $('.special_form').remove();
  },
  
  processListTitleForm: function (event) {
    if (event.type === "keypress" && event.keyCode !== 13) return;
    event.preventDefault();
    var listData = $(event.target).serializeJSON().list;
    this.model.save(listData);
  }
});