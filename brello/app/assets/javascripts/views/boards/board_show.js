// The board show view will have nested show views for each list and its cards.
Brello.Views.BoardShow = Backbone.View.extend({
  template: JST['boards/show'],
  
  className: 'board',
  
  events: {
    'submit #new_list_form': 'processNewList',
    'keypress #new_list_form': 'processNewList',
    'click .list-delete': 'deleteList',
    
    // handle the popup form for editing board title.
    'click #board_title': 'displayBoardTitleEditForm',
    'submit #board_title_form': 'processBoardTitleForm',
    'keypress #board_title_form': 'processBoardTitleForm',
    
    // add a collaborator
    'submit #add_member_form': 'addMember',
    'click .member-delete': 'deleteMember',
    
    // keep track of new list focus between renders
    'focus #new_list_form textarea': 'focusForm',
    'click': 'dismissFormsOnBackgroundClick',
  },
  
  initialize: function () {
    this.listenTo(this.model, "change", this.render);
    this.listenTo(this.collection, "change add remove sort", this.render);
    this.$el.attr('data-id', this.model.get('id'));
  },
  
  render: function () {
    var that = this;

    this.$el.html(this.template({
      board: this.model,
    }));
    
    // nested list views
    this.model.get('lists').each(function (list) {
      var listView = new Brello.Views.ListShow({
        model: list,
        collection: list.get('cards')
      });
      that.$el.find('#new_list').before(listView.render().$el);
    });

    this.setupSortable();
    if (this.newListFormActive) {
      $('#new_list_form textarea').focus();
    }
    return this;
  },
  
  setupSortable: function () {
    var that = this;
    
    this.$el.find('.list-sortable').sortable({
      items: '.list',
      tolerance: 'pointer',
      placeholder: 'list-dropzone',
      revert: 200,
      
      start: function (event, ui) {
        ui.item.find('.list_title').addClass('noclick');
        ui.item.toggleClass('list dragging_list');
        ui.placeholder.height(ui.item.height());
      },
      
      beforeStop: function(event, ui) {
        that.moveList(event, ui);
      }
    });
  },
  
  processNewList: function (event) {
    var that = this;
    if (event.type === 'keypress' && event.keyCode !== 13) return;
    event.preventDefault();
    
    var listData = $(event.target).serializeJSON().list;
    // TODO: this is no good. why does listData produce too much nesting,
    // and why do I need to add cards here?
    var list = new Brello.Models.List(listData);
    if (list.get('title').length < 1) return;
    list.set('board', this.model);
    
    list.save();
  },
  
  // handler for drag&drop lists
  moveList: function (event, ui) {
    debugger
    var list = Brello.Models.List.findOrCreate({ id: ui.item.data('id') });

    // Find the immediately preceding element that is a list.
    var precedingId = $('.list-dropzone').prevAll('.list').first().data('id');
    var precedingList = Brello.Models.List.findOrCreate({ id: precedingId });
    // The insert position is one more than the preceding list's,
    // or just one if there are no preceding.
    var insertPos = precedingId ? (precedingList.get('position') + 1) : 1;

    // If we're inserting after the original position we have to adjust the
    // new pos down because one of the lists before (the list being removed)
    // will no longer be there after the move.
    if (insertPos > list.get('position')) insertPos -= 1;
    if (insertPos === list.get('position')) return; // No move necessary.
    
    this.collection.move(list.get('id'), insertPos);
    ui.item.toggleClass('list dragging_list');
  },
  
  deleteList: function (event) {
    var that = this;
    
    event.preventDefault();
    event.stopPropagation();
    // Destroy in the callback so the re-render doesn't interrupt the fade.
    var listDiv = $(event.target).parents('.list');
    var list = this.collection.get(listDiv.data('id'));
    listDiv.fadeOut(400, function () {
      that.model.destroyList(list.get('id'));
    });
  },
  
  displayBoardTitleEditForm: function (event) {
    event.stopPropagation();
    
    $('.special_form').remove();
    
    var form = $(JST['shared_text_form']({
      submitAs: 'board[title]',
      placeholderText: $(event.target).html(),
      formName: 'board_title_form'
    }));
    
    this.$el.append(form);
    
    form.css({
      top: event.clientY + "px",
      left: event.clientX + "px"
    });
    
    $('form textarea').focus().select();
  },
  
  processBoardTitleForm: function (event) {
    if (event.type === 'keypress' && event.keyCode !== 13) return;
    event.preventDefault();
    var boardData = $(event.target).serializeJSON().board;
    this.model.save(boardData);
  },
  
  addMember: function (event) {
    var that = this;
    event.preventDefault();
    var userInfo = $(event.target).serializeJSON().membership
    
    $.ajax({
      type: 'POST',
      url: '/boards/' + this.model.get('id') + '/memberships',
      data: userInfo,
      dataType: 'JSON',
      
      success: function (membershipData) {
        that.model.get('memberships').add(membershipData);
        that.render();
      },
      
      error: function () {
        $error = $('<li>').addClass('member_error').html('No user found');
        $(event.target).find('[type=text]').after($error)
        setTimeout(function () {
          $error.fadeOut('slow', function () {
            $error.remove();
          });
        }, 2000);
      }
    });
  },
  
  deleteMember: function (event) {
    var that = this;
    event.preventDefault();
    var id = $(event.target).data('id');
    var membership = this.model.get('memberships').get(id);
    membership.destroy({
      success: function () {
        that.model.trigger('change');
      }
    });
  },
  
  // Keeps track of the focus/blur state of the new list form
  // so that when the view rerenders it can focus the form if necessary.
  focusForm: function (event) {
    this.newListFormActive = true;
  },
  
  dismissFormsOnBackgroundClick: function (event) {
    // Blur the new list form.
    if (!$(event.target).is('#new_list_textarea')) {
      this.newListFormActive = false;
    }
    // If user clicks dismiss button on popup form
    // or the click is outside a popup form.
    if ($(event.target).hasClass('dismiss_special_form') ||
        $(event.target).parents('.special_form').length === 0) {
      // event.preventDefault();
      $('.special_form').remove();    
    }
    // Dismissing of new card form on background clicks.
    // There must be a new card form visible
    // and the click cannot occur within the new card div.
    if ($('.new_card_form').length > 0 &&
        $(event.target).parents('.new_card').length === 0) {
      // This feels dirty: this is the same code that's in the
      // card index view, and this really should be there, but
      // not sure at the moment the best way to delegate to the
      // appropriate subview(s).
      $('.new_card_form').css('display', 'none');
      $('.new_card_link').css('display', 'block');
    }
  },
});