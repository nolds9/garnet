var updateAttendance = function(form){
  var url = form.attr("action")
  var data = form.serialize()
  var status = form.find(":checked").val()
  var token = form.find("[name='authenticity_token']").val()
  $.ajax({
    url: url,
    dataType: "json",
    method: "PATCH",
    data: {
      attendance: {
        status: status
      },
      authenticity_token: token
    }
  })
};

$(function(){
  $("body").on("change", ".attendance form", function(e){
    e.preventDefault()
    e.stopPropagation()
    updateAttendance($(this))
  })
})
