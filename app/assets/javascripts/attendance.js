var updateAttendance = function(){
  console.log("clicked");
  data = {attendance: {}};
  data.attendance.status = $(this).val();
  data.attendance_id = $(this).parent().parent().find('#attendance_id').val();

  console.log(data);

    $.ajax({
      url: "/update_attendance",
      dataType: "json",
      type: "patch",
      data: data
    }).then(function(response){
      console.log(response);
    });

};
