var search_div = $('#instant-search-div');
if(search_div.length > 0) {
  // Templating engine; makes stuff look nice :)
  var templater = {
    compile: function(template) {
      var template = '';
      template += '<div class="instant-result">';
      template += '<img class="instant-img pull-left" src={{img}} alt="" />';
      template += '<p class="instant-val">{{value}}</p>';
      template += '<p class="instant-sub">{{sub}}</p>';
      template += '</div>';
      template += '<hr';

      return {
        render: function(context) {
          return template
            .replace('{{url}}', context.url)
            .replace('{{value}}', context.value)
            .replace('{{img}}', context.img)
            .replace('{{sub}}', context.sub);
        }
      }
    }
  }

  var query_path = "/query.json";
  var full_search_path = "/search";
  var searchbar = $('#instant-search');
  searchbar.removeClass('instant-search-beforeLoad');

  searchbar.typeahead({
    name: 'instant',
    remote: {
      url: query_path + '?q=%QUERY&t=i',
      dataType: "json"
    },
    rateLimitWait: 100,
    template: '',
    engine: templater,
    limit: 5
  });

  searchbar.on('typeahead:selected', function(event, selected) {
    if(selected.url.length > 0)
      window.location = selected.url;
  });

  var autocompleted_url = false;
  searchbar.on('typeahead:autocompleted', function(event, completed) {
    autocompleted_url = completed.url;
  });

  searchbar.keydown(function(event){
    if(event.which == 13) { // The enter key
      if(autocompleted_url) {
        window.location = autocompleted_url;
      }
      else {
        window.location = full_search_path;
      }
    }
    // On delete or backspace; disregard the old autocomplete
    else if(event.which == 8 || event.which == 46) {
      autocompleted_url = false;
    }
  });

  // focussing and blurring (fancy; clicking a suggestion is no blur)
  var focusin = false;
  $(document).mouseup(function (e) {
    // Do we have focus?
    if (search_div.is(e.target) || search_div.has(e.target).length != 0) {
      // yes; we have focus
      if(!focusin) { // Are we gaining focus?
        $('.hide-on-search').toggle(150, function() {
          search_div.animate({width: 320}, 200);
        });
        focusin = true;
      }
    }
    else { 
      // no; we have no focus
      if(focusin) { //Are we losing focus?
        search_div.animate({width: 100}, 200, function() {
          $('.hide-on-search').toggle(150);
        });
        focusin = false;
      }
    }
  });
}