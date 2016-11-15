function randInt (min, max)
{
  return Math.floor(Math.random() * (max - min + 1)) + min;  
}

function areaSize()
{
  var txtStart = '<textarea id="wordlist" rows=';
  var txtEnd = '></textarea><br /><input type=button value="Submit" onclick="mkTable()"/><br />';
  document.getElementById("txt").innerHTML = txtStart + numEntries() + txtEnd;
}

function numEntries()
{
  cols = document.getElementById('cols').value;
  rows = document.getElementById('rows').value;  
  freeSpace = document.getElementById('freespace').checked;
  if (freeSpace){ return rows*cols-1;}
  else {return rows*cols;}
}

/*
  HTML Tables are awful, but I can't think of another way to do this 
  If there's a bette way, please submit a pull reuqest with something else
*/
function mkTable ()
{
  var e = document.getElementById("txt");
  e.style.display = 'none';
  var contents = '<table><th colspan="' + cols + '">Bullshit Bingo</th>';
  var werds = document.getElementById('wordlist').value.split("\n");
  var len = werds.length;
  // fail if we have less entires than we need
  if (len < numEntries()) 
  {  
    alert("Not enough words to make that board");
    areaSize();
    return ;
  }
  var remLen = len;

  for (i=0; i < rows; i++)
  {
    contents += '<br />\n<tr>\n';
    for (j=0; j < cols; j++)
    {     
          cell = 'c' + i + 'x' + j;
          //console.log(cell);
          werd = werds[randInt(0,remLen -1)];
          contents+='<td id="' + cell + '"><a href="#" onclick="cellToggle(this.id);">' + werd + "</a></td>";
          werds.splice(werds.indexOf(werd),1);
          remLen --;
    }
    contents += '\n</tr>';
  }
  contents += '\n</table>';
  document.getElementById("table").innerHTML = contents;
}

function cellToggle (cell)
{
 // stub
  console.log(cell);
  var d = document.getElementById(cell);
  d.className += "clicked";
}