function submit ()
{
  console.log("Called submit");
  var cols = document.getElementById('cols').value;
  var rows = document.getElementById('rows').value;
  var werdsArray = document.getElementById('wordlist').value.split("\n");
  //window.alert("Rows: " + rows + "\nCols: " + cols);
  //document.getElementById("res").innerHTML = rows + "x" + cols + "<br />List:<br />" + werds;
  for (i=0; i <= werdsArray.length; i++)
  {
    console.log(werdsArray[i]);
  }
}