# TODO: turn this into ajax. See http://railscasts.com/episodes/340-datatables

jQuery ->
  $('#tx').dataTable
    "aaSorting" : [[0, 'desc']]
    
	
