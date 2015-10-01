var updateAttendance = function(form){
  var url = form.attr("action")
  console.log(url)
  
  $.ajax({
    url: url,
    dataType: "json",
    method: "PATCH",
    data: form.serialize()
  }).then(function(res){
    console.log(res) 
  })
};

$(function(){
  $("body").on("change", ".attendance form", function(e){
    e.preventDefault()
    e.stopPropagation()
    updateAttendance($(this))
  })
})
