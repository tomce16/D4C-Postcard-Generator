//Import, export data.
Table CardTable;

void ReadTable(){
  CardTable = loadTable("card.csv", "header"); 
  PrintTable(CardTable);
}

//Ad one additional row and save the table
void AddDataToTable(Table table){
  TableRow newRow = table.addRow();
  newRow.setInt("id", table.lastRowIndex());
  newRow.setString("color", ""+c);
  newRow.setString("size", ""+s);
  newRow.setString("element", ""+e);
  SaveCardTable();
}

void SaveCardTable(){
  saveTable(CardTable, "data/card.csv");
}

void PrintTable(Table table){
  println(table.getRowCount() + " total rows in table"); 

  for (TableRow row : table.rows()) {
    
    int id = row.getInt(0);
    String c1 = row.getString(1);
    String c2 = row.getString(2);
    
    println(" | ",id, " | ", c1, " | ", c2, " | "); 
  }
  
}
