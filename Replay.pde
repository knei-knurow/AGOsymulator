//tu będzie zapisywanie i odwieranie powtórek

String sciezkaPowtorki = ""; 
Boolean Powtorka = false;

void fileSelected(File selection)
{
    if (selection == null)
    {
        println("Window was closed or the user hit cancel.");
    }
    else
    {
        println("User selected " + selection.getAbsolutePath());
        sciezkaPowtorki = selection.getAbsolutePath();
        importPowtorki();
    }
    
}

void zapisPowtorki()
{
    zapisano = 1;
       
    JSONArray values;

    values = new JSONArray();
  
    
    //1
    JSONObject naglowekStartu = new JSONObject();
    
    naglowekStartu.setInt("id", 0);
    
    naglowekStartu.setFloat("xPocz", kursor_pocz_x);
    naglowekStartu.setFloat("yPocz", kursor_pocz_y);
    naglowekStartu.setFloat("azymutPocz", dane_azymut[0]);
    naglowekStartu.setFloat("wysokoscPocz", dane_wysokosc[0]);
    
    values.setJSONObject(0, naglowekStartu);
    
    //2
    JSONObject naglowekZmiennych = new JSONObject();
    
    naglowekZmiennych.setInt("id", 1);
    
    naglowekZmiennych.setString("Zmienna1", "linkaP");
    naglowekZmiennych.setString("Zmienna2", "linkaL");
    naglowekZmiennych.setString("Zmienna3", "aktualnyAlgorytm");
    
    values.setJSONObject(1, naglowekZmiennych);
    
    for (int i = 0; i < dane_azymut.length - 1; i++) 
    {
        //3, 5, 7, 9, 11, itd...
        JSONObject tablicaLotu = new JSONObject();
    
        tablicaLotu.setInt("id", i*2 + 2);
        
        tablicaLotu.setFloat("xCansata",        x_teraz[i]);
        tablicaLotu.setFloat("yCansata",        y_teraz[i]);
        tablicaLotu.setFloat("azymutCansata",   dane_azymut[i]);
        tablicaLotu.setFloat("szybkoscCansata", dane_przesuniecie[i]);
        tablicaLotu.setFloat("wiatrZielonyX",   x_wiatr_zielony[i]);
        tablicaLotu.setFloat("wiatrZielonyY",   y_wiatr_zielony[i]);
        tablicaLotu.setFloat("wiatrFioletowyX", x_wiatr_fioletowy[i]);
        tablicaLotu.setFloat("wiatrFioletowyY", y_wiatr_fioletowy[i]);
        tablicaLotu.setFloat("wysokosci",       dane_wysokosc[i]);
        
        values.setJSONObject(i*2 + 2, tablicaLotu);
        
        //4, 6, 8, 10, 12, itd...
        JSONObject tablicaZmiennych = new JSONObject();
    
        tablicaZmiennych.setInt("id", i*2 + 3);
        
        tablicaZmiennych.setString("linkaP", str(linka_P));
        tablicaZmiennych.setString("linkaL", str(linka_L));
        tablicaZmiennych.setString("aktualnyAlgorytm", faza_algorytmu);
        
        values.setJSONObject(i*2 + 3, tablicaZmiennych);
    }
    

    
    
    String nazwa = str(year())        + "." 
        + zeraPoprzedzajace(month())  + "."
        + zeraPoprzedzajace(day())    + "_" 
        + zeraPoprzedzajace(hour())   + "." 
        + zeraPoprzedzajace(minute()) + "." 
        + zeraPoprzedzajace(second());
    
    String sciezka = "./JSON/" + nazwa + ".json";
    saveJSONArray(values, sciezka);  
    
    
    zapisano = 0;    
}

void wybieraniePliku()
{
    selectInput("Select a file to process:", "fileSelected");
}

void importPowtorki()
{
    if(sciezkaPowtorki != "")
    {
        Powtorka = true;
        zerowanieTablic();
        
        
        JSONArray values;
    
        values = loadJSONArray(sciezkaPowtorki);
        
        //1
        JSONObject naglowekStartu = values.getJSONObject(0); 
        
        if(naglowekStartu.getInt("id") == 0)
        {
            kursor_pocz_x = naglowekStartu.getFloat("xPocz");
            kursor_pocz_y = naglowekStartu.getFloat("yPocz");
            float azymutPocz = naglowekStartu.getFloat("azymutPocz");
            float wysokoscPocz = naglowekStartu.getFloat("wysokoscPocz");
        }
        
        
        //2
        JSONObject naglowekZmiennych = values.getJSONObject(1); 
        
        String[] nazwyZmiennych = {};
        
        if(naglowekZmiennych.getInt("id") == 1)
        {    
            for(int i = 1; i < 10; i++)
            {
                if(naglowekZmiennych.getString("Zmienna" + i) != null)
                {
                    nazwyZmiennych = append(nazwyZmiennych, naglowekZmiennych.getString("Zmienna" + i));
                }
            }          
        }
        
        
        
        for (int i = 0; i*2+3 < values.size() ; i++) 
        {
            //3, 5, 7, 9, 11, itd...
            JSONObject tablicaLotu = values.getJSONObject(i*2 + 2);
            
            //tablicaLotu.setInt("id", i*2 + 2);
            
            x_teraz =           append(x_teraz,           tablicaLotu.getFloat("xCansata"));
            y_teraz =           append(y_teraz,           tablicaLotu.getFloat("yCansata"));
            dane_azymut =       append(dane_azymut,       tablicaLotu.getFloat("azymutCansata"));
            dane_przesuniecie = append(dane_przesuniecie, tablicaLotu.getFloat("szybkoscCansata"));
            x_wiatr_zielony =   append(x_wiatr_zielony,   tablicaLotu.getFloat("wiatrZielonyX"));
            y_wiatr_zielony =   append(y_wiatr_zielony,   tablicaLotu.getFloat("wiatrZielonyY"));
            x_wiatr_fioletowy = append(x_wiatr_fioletowy, tablicaLotu.getFloat("wiatrFioletowyX"));
            y_wiatr_fioletowy = append(y_wiatr_fioletowy, tablicaLotu.getFloat("wiatrFioletowyY"));        
            dane_wysokosc =     append(dane_wysokosc,     tablicaLotu.getFloat("wysokosci"));
            
            //4, 6, 8, 10, 12, itd...            
            JSONObject tablicaZmiennych = values.getJSONObject(i*2 + 3);
            String[][] Zmienne = new String[nazwyZmiennych.length][5001];
          
            for(int j = 0; j < nazwyZmiennych.length; j++)
            {
                Zmienne[j][i] = tablicaZmiennych.getString(nazwyZmiennych[j]); 
            }
        }
 
    }

}
