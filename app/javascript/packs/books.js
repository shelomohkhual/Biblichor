$(document).on('turbolinks:load', function(){
  var books = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/books/autocomplete?query=%QUERY',
      wildcard: '%QUERY'
    }
  });
  $('#books_search').typeahead(null, {
    source: books
  });
})