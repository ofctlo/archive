Brello.Views.CardShow = Backbone.View.extend({  
  template: JST['cards/show'],
  
  events: {
    'click .card_background': 'dismiss',
    
    'click .card_title': 'displayCardTitleEditForm',
    'click .dismiss_special_form': 'dismissSpecialForm',
    'submit #card_title_form': 'processCardTitleForm',
    
    'click #edit_description_link': 'displayEditDescriptionForm',
    'submit #description_form': 'processDescription',
    
    'click #add_checklist': 'showChecklistForm',
    'submit #checklist_form': 'submitChecklistForm',
    'click .checkbox': 'checkItem',
    
    'click #add_due_date': 'showDueDateForm',
    'submit #due_date_form': 'submitDueDateForm'
  },
  
  initialize: function () {
    this.listenTo(this.model, "change", this.render);
  },
  
  render: function () {
    this.$el.html(this.template({ card: this.model }));
    
    var checklistsIndexView = new Brello.Views.ChecklistsIndex({
      collection: this.model.get('checklists')
    });
    this.$el.find('#checklists').html(checklistsIndexView.render().$el);
  
    return this;
  },
  
  dismiss: function (event) {
    // if the click is inside the card don't dismiss.
    if ( $(event.target).parents('.card').length > 0 || 
         $(event.target).hasClass('card') ) {
      event.stopPropagation();
      return;
    }
    board = this.model.get('list').get('board');
    
    this.undelegateEvents();
    Backbone.history.navigate('#/boards/' + board.get('id'), true);
  },
  
  displayEditDescriptionForm: function (event) {
    event.preventDefault();
    event.stopPropagation();
    
    $('#description').html(JST['cards/edit_description_form']({
      card: this.model
    }));
  },
  
  processDescription: function (event) {
    var that = this;
    event.preventDefault();
    
    var descriptionData = $(event.target).serializeJSON().card;
    this.model.save(descriptionData, {
      success: function (card) {
        that.render();
      }
    });
  },
  
  showChecklistForm: function (event) {
    event.stopPropagation();
    var renderedForm = JST['cards/checklist_form']();
    this.$checklistButton = $(event.target).replaceWith(renderedForm);
  },
  
  submitChecklistForm: function (event) {
    event.preventDefault();
    var checklistData = $(event.target).serializeJSON().checklist;    
    var checklist = new Brello.Models.Checklist(checklistData);
    this.model.get('checklists').add(checklist, { wait: true });
    
    checklist.save();
    
    $(event.target).replaceWith(this.$checklistButton);
  },
  
  showDueDateForm: function (event) {
    event.stopPropagation();
    var renderedForm = JST['cards/due_date_form']();
    this.$dueDateButton = $(event.target).replaceWith(renderedForm);
  },
  
  submitDueDateForm: function (event) {
    event.preventDefault();
    var dueDateData = $(event.target).serializeJSON().card.due_date;
    this.model.save({ due_date: dueDateData })
  },
  
  displayCardTitleEditForm: function (event) {
    $('.special_form').remove();
    
    var form = $(JST['shared_text_form']({
      submitAs: 'card[title]',
      placeholderText: $(event.target).html(),
      formName: 'card_title_form'
    }));
    
    this.$el.append(form);
    
    form.css({
      top: event.clientY + "px",
      left: event.clientX + "px"
    });
  },
  
  dismissSpecialForm: function (event) {
    event.preventDefault();
    event.stopPropagation();
    $('.special_form').remove();
  },
  
  processCardTitleForm: function (event) {
    event.preventDefault();
    var cardData = $(event.target).serializeJSON().card;
    this.model.save(cardData);
  }
});