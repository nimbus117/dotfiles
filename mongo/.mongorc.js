// custom prompt
host = db.serverStatus().host;
prompt = function() {
  return db+" > ";
}

// 
function describe(collection) {
  var col_list = collection.findOne();
  for (var col in col_list) { print (col) ;  }
}
