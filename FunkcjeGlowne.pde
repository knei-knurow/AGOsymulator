////////////////////////////////////////////////////DEFINICJA WARUNKÓW///////////////////////////////

boolean kursor_jest_na_mapie(int x, int y)                //sprawdza czy pozycja myszki mieści się na mapie
{
    return (x > mapa_pocz_x && x < mapa_pocz_x + mapa_szer && y > mapa_pocz_y && y < mapa_pocz_y + mapa_wys );
}


boolean kursor_jest_na_mapie_wiatru(int x, int y)         //sprawdza czy pozycja myszki mieści się na mapie wiatru
{
    return (x >= 1010 && x <= 1366 && y >= 412 && y <= 768);
}

////////////////////////////////////////////////////ZMIENNE PO PRAWEJ//////////////////////////////

//jaka (co napisać najpierw), ile (wartość zmiennej), gdzie (współrzędne)

void pokaz_zmienna_po_prawej(String jaka, float ile, int gdzie)
{
    stroke(255);                                           //kolor obramowania (biały)
    textSize(24);                                          //grubość czcionki
    fill(0, 102, 153);                                     //wypełnienie (niebieski)
    textAlign(LEFT);
    text(jaka, trzyde.width + 10, gdzie + 30);             //pokaż wartość
    textAlign(RIGHT);
    text(ile, trzyde.width + 356, gdzie + 30);             //pokaż wartość
}

void pokaz_zmienna_po_prawej(String jaka, String ile, int gdzie)
{
    stroke(255);                                           //kolor obramowania (biały)
    textSize(24);                                          //grubość czcionki
    fill(0, 102, 153);                                     //wypełnienie (niebieski)
    textAlign(LEFT);
    text(jaka, trzyde.width + 10, gdzie + 30);             //pokaż wartość
    textAlign(RIGHT);
    textSize(19);
    text(ile, trzyde.width + 356, gdzie + 30);             //pokaż wartość
    textSize(24);
}

////////////////////////////////////////////////////RYSOWANIE MAPY//////////////////////////////

void setup3D()
{
    background(0);                                       // tło 2d (wymazanie starej klatki)
  
    trzyde.beginDraw();                                  // ustawienia 3d (nie zmieniać)
    trzyde.lights();                                     //
    trzyde.background(0);                                //
    camera.update();                                     //
    mouse.update();                                      //
    
    trzyde.pushMatrix();
    trzyde.rotateX(radians(90));
    trzyde.translate(-600, -390, 0);       //przesuniecie planszy
}

void rysujMape()
{
    //mapa
    trzyde.stroke(255, 0, 0, 80);          //linie podziałki
    
    for(int x=0; x < mapa_szer; x += 20) trzyde.line(mapa_pocz_x + x, mapa_pocz_y + 1, mapa_pocz_x + x, mapa_pocz_y + mapa_wys - 2);     //pionowe
    for(int y=0; y < mapa_wys; y += 20) trzyde.line(mapa_pocz_x + 1, mapa_pocz_y + y, mapa_pocz_x + mapa_szer - 2, y + mapa_pocz_y);     //pioziome  
  
    trzyde.stroke(255, 255, 255);                                                                                   //ramka
    trzyde.line(mapa_pocz_x, mapa_pocz_y, mapa_pocz_x + mapa_szer - 1, mapa_pocz_y);                                     //  
    trzyde.line(mapa_pocz_x, mapa_pocz_y, mapa_pocz_x, mapa_pocz_y + mapa_wys - 1);                                      //          
    trzyde.line(mapa_pocz_x + mapa_szer - 1, mapa_pocz_y, mapa_pocz_x + mapa_szer - 1, mapa_pocz_y + mapa_wys - 1);      //
    trzyde.line(mapa_pocz_x, mapa_pocz_y + mapa_wys - 1, mapa_pocz_x + mapa_szer - 1, mapa_pocz_y + mapa_wys - 1);       //
    
    rysujPodzialke();
    rysujGraniceMapy();
}

void rysujPodzialke()
{
    //podziałka
    trzyde.strokeWeight(2.5);
    trzyde.stroke(255);
    trzyde.line(mapa_pocz_x, mapa_pocz_y, 0, mapa_pocz_x, mapa_pocz_y, wysokosc / wspolczynnik_wysokosci);
    trzyde.stroke(0, 255, 0);
    trzyde.line(mapa_pocz_x, mapa_pocz_y, wysokosc / wspolczynnik_wysokosci, mapa_pocz_x, mapa_pocz_y, 3000 / wspolczynnik_wysokosci);
    
    trzyde.stroke(255);
    for(int i = 0; i <= 60 / wspolczynnik_wysokosci; i++)
    {
        if(i != 0) if(((3000 / (60 / wspolczynnik_wysokosci)) * i) >= wysokosc) trzyde.stroke(0, 255, 0);
        trzyde.textSize(24);        
        trzyde.line(mapa_pocz_x, mapa_pocz_y, i * 50, mapa_pocz_x + 20, mapa_pocz_y, i * 50);
        trzyde.rotateX(radians(-90));
        trzyde.text(i * 50 * wspolczynnik_wysokosci + " m", mapa_pocz_y + 20, -i * 50, mapa_pocz_x);
        trzyde.rotateX(radians(90));
    }
}

void rysujGraniceMapy()
{
    //obramowanie białymi liniami
    strokeWeight(5);
    stroke(255);
    line(trzyde_x, trzyde_y, trzyde_x + trzyde.width, trzyde_y);
    line(trzyde_x, trzyde_y, trzyde_x, trzyde_y + trzyde.height);
    line(trzyde_x + trzyde.width, trzyde_y, trzyde_x + trzyde.width, trzyde_y + trzyde.height);
    line(trzyde_x, trzyde_y + trzyde.height, trzyde_x + trzyde.width, trzyde_y + trzyde.height);
}

void okregiZasiegu()
{
    trzyde.noFill();                //bez wypełnienia
    trzyde.stroke(190, 51, 255);    //kolor obramowania (fioletowy)
    trzyde.strokeWeight(1);         //grubość
    
    x_srodka_okregu = int(10000 * (cel_x + (x_do_celu/10000.) + wysokosc * szybkosc_cansata * 1.2 / szybkosc_opadania * (LIN_wiatr_x/1000.)));        //obliczanie x i y środka koła uwzględniając wiatr
    y_srodka_okregu = int(10000 * (cel_y + (y_do_celu/10000.) + wysokosc * szybkosc_cansata * 1.2 / szybkosc_opadania * (LIN_wiatr_y/1000.)));        //
    odleglosc_srodka_okregu_do_celu = int(10000 * (sqrt(sq(cel_x - x_srodka_okregu/10000.) + sq(cel_y - y_srodka_okregu/10000.))));                   //odległość od środka koła do celu
    promien_okregu = int(10000 * wysokosc * szybkosc_cansata * 1.2 / szybkosc_opadania);  //okrąg zasięgu
    
    //koło gdzie może dolecieć cansat (fioletowe)
    if(nowa_symulacja == false)  //jeżeli program właśnie się nie restartuje
    {
        trzyde.circle((x_srodka_okregu/10000. + x_strzalki) * skala, (y_srodka_okregu/10000. + y_strzalki) * skala, promien_okregu/10000. * 2 * skala);
    }

    //koło gdzie ma wylądować CanSat
    trzyde.stroke(7, 219, 219);     //kolor obramowania (niebieski)
    trzyde.circle((cel_x + x_strzalki) * skala, (cel_y + y_strzalki) * skala, srednica_kola * skala);
}

////////////////////////////////////////////////////RYSOWANIE SCIEŻKI//////////////////////////////

void nowyKrok()
{
    if(dane_azymut.length - 1 == x_teraz.length)       //jeżeli to jego ostatni ruch to oblicza ile sie w sumie przesunął
    {
        //obliczanie o ile przesunął sie cansat (wiatr i azymut)
        rysowany_x += sin(radians(dane_azymut[dane_azymut.length - 1])) * dane_przesuniecie[dane_azymut.length - 1] * 1.2;              //x azymut
        rysowany_y += cos(radians(dane_azymut[dane_azymut.length - 1])) * dane_przesuniecie[dane_azymut.length - 1] * 1.2;              //y azymut
        rysowany_x += sin(radians(azymut_wiatru_tablica[dane_azymut.length - 1])) * sila_wiatru_tablca[dane_azymut.length - 1] * 1.2;   //x wiatr
        rysowany_y += cos(radians(azymut_wiatru_tablica[dane_azymut.length - 1])) * sila_wiatru_tablca[dane_azymut.length - 1] * 1.2;   //y wiatr
        
        x_teraz = append(x_teraz, rysowany_x);      //dodaje do tablicy ile przesunął się w ostatnim kroku x i y
        y_teraz = append(y_teraz, rysowany_y);      //można zamiast tablicy dać zmienną
    }       
    rysowany_x = x_teraz[dane_azymut.length - 1];      //zczytuje z tablicy ile przesunąl się w danym ruchu w x i y
    rysowany_y = y_teraz[dane_azymut.length - 1];      //
}

void rysujSciezke_2D(int dokladnosc)
{
    trzyde.stroke(255, 255, 0);
    trzyde.strokeWeight(1);
    for(int i = 1; i < dane_azymut.length; i+=dokladnosc)
    {
        if(i - dokladnosc < 0)
        {
            trzyde.line((kursor_pocz_x + x_strzalki + x_teraz[0]) * skala,
                        (kursor_pocz_y + y_strzalki - y_teraz[0]) * skala, 0,
                        (kursor_pocz_x + x_strzalki + x_teraz[i]) * skala, 
                        (kursor_pocz_y + y_strzalki - y_teraz[i]) * skala, 0);
        }
        else
        {
            trzyde.line((kursor_pocz_x + x_strzalki + x_teraz[i-dokladnosc]) * skala,
                        (kursor_pocz_y + y_strzalki - y_teraz[i-dokladnosc]) * skala, 0,
                        (kursor_pocz_x + x_strzalki + x_teraz[i]) * skala, 
                        (kursor_pocz_y + y_strzalki - y_teraz[i]) * skala, 0);            
        }
                   
        if(i + dokladnosc >= dane_azymut.length)
        {
            trzyde.line((kursor_pocz_x + x_strzalki + x_teraz[i]) * skala,
                        (kursor_pocz_y + y_strzalki - y_teraz[i]) * skala, 0,
                        (kursor_pocz_x + x_strzalki + x_teraz[dane_azymut.length - 1]) * skala,
                        (kursor_pocz_y + y_strzalki - y_teraz[dane_azymut.length - 1]) * skala,   0);
        }
    }
}

void rysujSciezke_3D(int dokladnosc)
{
    trzyde.stroke(255, 155, 155);
    trzyde.strokeWeight(1);
    
    for(int i = 1; i < dane_azymut.length - 1; i+=dokladnosc)
    {
        if(i - dokladnosc < 0)
        {
            if(dane_wysokosc.length > 1 && dane_wysokosc[1] != 0 && dane_wysokosc[i] != 0)
            {
                trzyde.line((kursor_pocz_x + x_strzalki + x_teraz[0]) * skala,
                            (kursor_pocz_y + y_strzalki - y_teraz[0]) * skala,
                            dane_wysokosc[1] / wspolczynnik_wysokosci,
                            (kursor_pocz_x + x_strzalki + x_teraz[i]) * skala, 
                            (kursor_pocz_y + y_strzalki - y_teraz[i]) * skala,
                            dane_wysokosc[i] / wspolczynnik_wysokosci);
            }
        }
        else
        {
            if(dane_wysokosc[i-dokladnosc] != 0 && dane_wysokosc[i] != 0)
            {
                trzyde.line((kursor_pocz_x + x_strzalki + x_teraz[i-dokladnosc]) * skala,
                        (kursor_pocz_y + y_strzalki - y_teraz[i-dokladnosc]) * skala,
                        dane_wysokosc[i-dokladnosc] / wspolczynnik_wysokosci,
                        (kursor_pocz_x + x_strzalki + x_teraz[i]) * skala, 
                        (kursor_pocz_y + y_strzalki - y_teraz[i]) * skala,
                        dane_wysokosc[i] / wspolczynnik_wysokosci);
            }           
        }
                   
        if(i + dokladnosc >= dane_azymut.length - 1)
        {
            trzyde.line((kursor_pocz_x + x_strzalki + x_teraz[i]) * skala,
                        (kursor_pocz_y + y_strzalki - y_teraz[i]) * skala,
                        dane_wysokosc[i] / wspolczynnik_wysokosci,
                        (kursor_pocz_x + x_strzalki + x_teraz[dane_azymut.length - 2]) * skala,
                        (kursor_pocz_y + y_strzalki - y_teraz[dane_azymut.length - 2]) * skala,
                        dane_wysokosc[dane_azymut.length - 2] / wspolczynnik_wysokosci);
        }
    }
    
    rysujStrzalke_3D();
    if(czyRysowacOdczytyWiatru == true)
    {
        rysujOdczytyWiatru();
    }
    
}

void rysujStrzalke_3D()
{
    trzyde.pushMatrix();
    if(dane_azymut.length - 2 < 0)
    {
        trzyde.translate((kursor_pocz_x + x_strzalki + x_teraz[0]) * skala,
                         (kursor_pocz_y + y_strzalki - y_teraz[0]) * skala,
                         dane_wysokosc[0] / wspolczynnik_wysokosci);
    }
    else
    {
        trzyde.translate((kursor_pocz_x + x_strzalki + x_teraz[dane_azymut.length - 2]) * skala,
                         (kursor_pocz_y + y_strzalki - y_teraz[dane_azymut.length - 2]) * skala,
                         dane_wysokosc[dane_azymut.length - 2] / wspolczynnik_wysokosci);
    }                
    trzyde.rotateZ(radians(270));
    
    if(nowa_symulacja == false)
    {
        //rysowanie wektoru (strzałki)
        trzyde.strokeWeight(4);                                                       //grubość
        trzyde.stroke(102, 255, 102);                                                 //kolor obramowania (różowy) 
        trzyde.rotateZ(radians(dane_azymut[dane_azymut.length - 1]));                 //obrócenie na aktualny azymut
        
        trzyde.line(0, 0, dane_przesuniecie[dane_przesuniecie.length - 1] * 25 * skala, 0);
        trzyde.line((dane_przesuniecie[dane_przesuniecie.length - 1] * 25 - 10) * skala, 10 * skala, dane_przesuniecie[dane_przesuniecie.length - 1] * 25 * skala, 0);
        trzyde.line((dane_przesuniecie[dane_przesuniecie.length - 1] * 25 - 10) * skala, -10 * skala, dane_przesuniecie[dane_przesuniecie.length - 1] * 25 * skala, 0);
        
        trzyde.rotateZ(radians(360 - dane_azymut[dane_azymut.length - 1]));            //obrócenie się do góry
    }
    
    trzyde.popMatrix();
}


void rysujOdczytyWiatru()
{
    float poprzedniWiatr_x = x_wiatr_fioletowy[0];
    float poprzedniWiatr_y = y_wiatr_fioletowy[0];
    for(int i = 0; i < x_wiatr_fioletowy.length; i += FPS)
    {
        if(x_wiatr_fioletowy[i] != poprzedniWiatr_x)
        {
            rysujOdczytWiatu(i);
            poprzedniWiatr_x = x_wiatr_fioletowy[i];
            poprzedniWiatr_y = y_wiatr_fioletowy[i];
        }
    }
}

void rysujOdczytWiatu(int i)
{
    trzyde.strokeWeight(2);          //grubośc
    
    trzyde.stroke(0, 255, 0);        //kolor obramowania (zielony)
    
    trzyde.line((kursor_pocz_x + x_strzalki + x_teraz[i]) * skala,
                (kursor_pocz_y + y_strzalki - y_teraz[i]) * skala,
                dane_wysokosc[i] / wspolczynnik_wysokosci,
                (kursor_pocz_x + x_strzalki + x_teraz[i]) * skala + map(x_wiatr_zielony[i], -90, 90, -178, 178) * 0.1, 
                (kursor_pocz_y + y_strzalki - y_teraz[i]) * skala + map(y_wiatr_zielony[i], -90, 90, -179, 177) * 0.1,
                dane_wysokosc[i] / wspolczynnik_wysokosci);
                
    trzyde.stroke(255, 105, 180);    //kolor obramowania (różowy)

    trzyde.line((kursor_pocz_x + x_strzalki + x_teraz[i]) * skala,
                (kursor_pocz_y + y_strzalki - y_teraz[i]) * skala,
                dane_wysokosc[i] / wspolczynnik_wysokosci,
                (kursor_pocz_x + x_strzalki + x_teraz[i]) * skala + map(x_wiatr_fioletowy[i], -90, 90, -178, 178) * 0.1, 
                (kursor_pocz_y + y_strzalki - y_teraz[i]) * skala + map(y_wiatr_fioletowy[i], -90, 90, -179, 177) * 0.1,
                dane_wysokosc[i] / wspolczynnik_wysokosci);

}

void stareRysowanieSciezki_2D()
{
    //rysowanie wszystkich linii gdzie przeleciał cansat na mapie (na płasko) (żółte)
    trzyde.pushMatrix();                                                                                 //rozpoczecie matrixa
    trzyde.translate((kursor_pocz_x + x_strzalki) * skala, (kursor_pocz_y + y_strzalki) * skala, 0);     //przesówa się na punkt początkowy cansata
    trzyde.rotateZ(radians(270));                                                                        //obraca się do góry
    trzyde.stroke(255, 255, 0);                                                                          //kolor obramowania (żółty)
    trzyde.strokeWeight(1);
     
    for(int i = 1; i < dane_azymut.length; i++)          //powtarza tyle razy ile kroków wcześniej wykonał + 1
    {
        //azymut
        trzyde.rotateZ(radians(dane_azymut[i]));                        //obrót                     
        trzyde.line(0, 0, dane_przesuniecie[i] * 1.2 * skala, 0);       //rysowanie lini
        trzyde.translate(dane_przesuniecie[i] * 1.2 * skala, 0, 0);     //przejście
        trzyde.rotateZ(radians(360 - dane_azymut[i]));                  //obrót do pozycji wyjściowej 
        
        //wiatr siła i kierunek
        trzyde.rotateZ(radians(azymut_wiatru_tablica[i]));              //obrót
        trzyde.line(0, 0, sila_wiatru_tablca[i] * 1.2 * skala, 0);      //rysowanie lini
        trzyde.translate(sila_wiatru_tablca[i] * 1.2 * skala, 0, 0);    //przejście
        trzyde.rotateZ(radians(360 - azymut_wiatru_tablica[i]));        //obrót do pozycji wyjściowej
    }

    trzyde.popMatrix();
}

void stareRysowanieSciezki_3D()
{
    //rysowanie wszystkich linii gdzie przeleciał cansat
    trzyde.pushMatrix();                                          //rozpoczecie macierzy  (matrycy)
    trzyde.translate((kursor_pocz_x + x_strzalki) * skala, (kursor_pocz_y + y_strzalki) * skala, dane_wysokosc[0] / wspolczynnik_wysokosci);      //przesuwa się na punkt początkowy cansata
    trzyde.rotateZ(radians(270));                                 //obraca się do góry
    trzyde.stroke(255, 155, 155);                                 //kolor obramowania (różowy)
    trzyde.strokeWeight(1);
    

          
    for(int i = 1; i < dane_azymut.length; i++)          //powtarza tyle razy ile kroków wcześniej wykonał + 1
    {
        //azymut
        trzyde.rotateZ(radians(dane_azymut[i]));                        //obrót                     
        trzyde.line(0, 0, dane_przesuniecie[i] * 1.2 * skala, 0);       //rysowanie lini
        trzyde.translate(dane_przesuniecie[i] * 1.2 * skala, 0, 0);     //przejście
        trzyde.rotateZ(radians(360 - dane_azymut[i]));                  //obrót do pozycji wyjściowej 
        
        if(i != 1) trzyde.line(0, 0, 0, 0, 0, dane_wysokosc[i] / wspolczynnik_wysokosci - dane_wysokosc[i - 1] / wspolczynnik_wysokosci);
        trzyde.translate(0, 0, dane_wysokosc[i] / wspolczynnik_wysokosci - dane_wysokosc[i - 1] / wspolczynnik_wysokosci);
        
        //wiatr siła i kierunek
        trzyde.rotateZ(radians(azymut_wiatru_tablica[i]));              //obrót
        trzyde.line(0, 0, sila_wiatru_tablca[i] * 1.2 * skala, 0);      //rysowanie lini
        trzyde.translate(sila_wiatru_tablca[i] * 1.2 * skala, 0, 0);    //przejście
        trzyde.rotateZ(radians(360 - azymut_wiatru_tablica[i]));        //obrót do pozycji wyjściowej
    }

    if(nowa_symulacja == false)
    {
        //rysowanie wektoru (strzałki)
        trzyde.strokeWeight(4);                                                       //grubość
        trzyde.stroke(102, 255, 102);                                                 //kolor obramowania (różowy) 
        trzyde.rotateZ(radians(dane_azymut[dane_azymut.length - 1]));                 //obrócenie na aktualny azymut
        
        trzyde.line(0, 0, dane_przesuniecie[dane_przesuniecie.length - 1] * 25 * skala, 0);
        trzyde.line((dane_przesuniecie[dane_przesuniecie.length - 1] * 25 - 10) * skala, 10 * skala, dane_przesuniecie[dane_przesuniecie.length - 1] * 25 * skala, 0);
        trzyde.line((dane_przesuniecie[dane_przesuniecie.length - 1] * 25 - 10) * skala, -10 * skala, dane_przesuniecie[dane_przesuniecie.length - 1] * 25 * skala, 0);
        
        rotateZ(radians(360 - dane_azymut[dane_azymut.length - 1]));            //obrócenie się do góry
    }
    
    trzyde.popMatrix();                                                         //koniec matrixa
}

////////////////////////////////////////////////////RYSOWANIE NA MAPIE//////////////////////////////

void rysujLinieObliczjacaWiatr()
{
    if(LIN_i == 0 && blisko_celu == 0 || LIN_i == 0 && blisko_celu == 2)        //gdy leci do celu i oblicza wiatr rysuje zieloną linie
    {
        if(restart == 0 && nowa_symulacja == false)
        {
            if(czyRysowacZielonaLinie == true)
            {
                trzyde.stroke(0, 255, 0);              //kolor obramowania (zielony)
                trzyde.strokeWeight(2);                //grubość zależna od skali 
                trzyde.line((((LIN_x_pocz/10000.) + cel_x) + x_strzalki) * skala, (((LIN_y_pocz / 10000.) + cel_y) + y_strzalki) * skala, (x2/10000. + x_strzalki) * skala, (y2/10000. + y_strzalki) * skala);        //zielona linia skierowana od cansata w stronę celu
                trzyde.strokeWeight(3);                //grubość zależna od skali 
                trzyde.stroke(255, 0, 0);              //kolor obramowania (czerwony)
                trzyde.point((x1/10000. + x_strzalki) * skala, (y1/10000. + y_strzalki) * skala);    //czerwone kropki na końcach zielonej linii
                trzyde.point((x2/10000. + x_strzalki) * skala, (y2/10000. + y_strzalki) * skala);    //                
            }
        }
    }
}

void rysujCele()
{
    rysujPunktCelu();
    rysujZapasoweCele();
}

void rysujPunktCelu()
{
    //rysowanie punktu celu
    trzyde.strokeWeight(10);                                     //grubośc
    trzyde.stroke(255, 0, 0);                                    //kolor obramowania (czerwony)
    trzyde.point((cel_x + x_strzalki) * skala, (cel_y + y_strzalki) * skala);                  //rysowanie punktu do którego zmierza cansat
}

void rysujZapasoweCele()
{
    //rysowanie zapasowych celów
    trzyde.stroke(255, 0, 0, 127);                               //półprzeźroczysty czerwony
    for(int i = 0; i < cele_zapasowe_x.length; i++)              //tyle ile jest pomocniczych punktów
        trzyde.point(cele_zapasowe_x[i] + x_strzalki * skala, cele_zapasowe_y[i] + y_strzalki * skala);    //pomocnicze punkty do których cansat dolatuje gdy nie zdąży do głównego punktu
}

void rysujFioletoweLinie()
{
    trzyde.strokeWeight(1);            //grubość
    trzyde.stroke(255, 0, 255);        //kolor obramowania (fioletowy)
    if(nowa_symulacja == false)            
    {
        //cztery linie od cansata do celu    (jedna w x, druga w y, trzecia po przekątnej a czwarta pionowa) 
        trzyde.line(((cel_x + x_do_celu/10000.) + x_strzalki) * skala, (cel_y + y_strzalki) * skala, ((cel_x + x_do_celu/10000.) + x_strzalki) * skala, ((cel_y + (y_do_celu/10000.)) + y_strzalki) * skala);
        trzyde.line((cel_x + x_strzalki) * skala, (cel_y + y_strzalki) * skala, ((cel_x + x_do_celu/10000.) + x_strzalki) * skala, (cel_y + y_strzalki) * skala);
        trzyde.line((cel_x + x_strzalki) * skala, (cel_y + y_strzalki) * skala, ((cel_x + x_do_celu/10000.) + x_strzalki) * skala, ((cel_y + (y_do_celu/10000.)) + y_strzalki) * skala);
        trzyde.line(((cel_x + x_do_celu/10000.) + x_strzalki) * skala, ((cel_y + (y_do_celu/10000.)) + y_strzalki) * skala, 0, ((cel_x + x_do_celu/10000.) + x_strzalki) * skala, ((cel_y + (y_do_celu/10000.)) + y_strzalki) * skala, wysokosc/wspolczynnik_wysokosci);
        
    }
}

////////////////////////////////////////////////////RYSOWANIE RESTART, ZMIENNYCH, LEGENDY I WERSJI SYMULATORA//////////////////////////////

void rysujPoPrawej()
{
    if(nowa_symulacja == true)      //restart miejsca gdzie jest cansat
    {
         wybieranieNowegoPunktu();
    }
    else if(nowa_symulacja == false)
    {
        panelZmiennych();
        rysujPrzyciski();
    }
}

void wybieranieNowegoPunktu()
{
    textAlign(LEFT);
        
    strokeWeight(1);
    stroke(255);                                    //kolor obramowania (biały)
    textSize(24);                                   //wielkość czcionki
     
    fill(0, 255, 0);
    rect(trzyde.width + 60, 250, 20, -wysokosc / 15);
    rect(trzyde.width + 60 - 10, 250 - wysokosc / 15 - 5, 20 + 20, 10, 5);
    
    fill(0, 102, 153);                              //wypełnienie (niebieski)
    text("Select the height ", trzyde.width + 120, 105);
    text("at which Cansat ",   trzyde.width + 120, 105 + 40);
    text("will start",         trzyde.width + 120, 105 + 80);

    text((int)wysokosc + " m", trzyde.width + 40, 35);

    text("Point the cursor to the ", trzyde.width + 20, 305);
    text("place from which CanSat",  trzyde.width + 20, 305 + 40);
    text("will start the flight",    trzyde.width + 20, 305 + 80);
    
    textAlign(RIGHT);
    
    
    camera.pos_x = 0;
    camera.pos_y = 0;
    camera.pos_z = 0;
    
    camera.dist = 700;
    
    camera.rot_x = 0;
    camera.rot_y = -89.5;
    
    if(mouseX > 63 && mouseX < 580 && mouseY > 18 && mouseY < 535 && mousePressed == true)
    {
        kursor_pocz_x = map(mouseX, 63, 580, 850, 2575);
        kursor_pocz_y = map(mouseY, 18, 535, 850, 2575);
        nowa_symulacja = false;
        restart = 200;
    }
}

void panelZmiennych()
{
    
    trzyde.strokeWeight(1);            //grubość
    trzyde.stroke(255, 0, 255);        //kolor obramowania (fioletowy)
    /*
    //cztery linie od cansata do celu    (jedna w x, druga w y, trzecia po przekątnej a czwarta pionowa) 
    trzyde.line(((cel_x + x_do_celu/10000.) + x_strzalki) * skala, (cel_y + y_strzalki) * skala, ((cel_x + x_do_celu/10000.) + x_strzalki) * skala, ((cel_y + (y_do_celu/10000.)) + y_strzalki) * skala);
    trzyde.line((cel_x + x_strzalki) * skala, (cel_y + y_strzalki) * skala, ((cel_x + x_do_celu/10000.) + x_strzalki) * skala, (cel_y + y_strzalki) * skala);
    trzyde.line((cel_x + x_strzalki) * skala, (cel_y + y_strzalki) * skala, ((cel_x + x_do_celu/10000.) + x_strzalki) * skala, ((cel_y + (y_do_celu/10000.)) + y_strzalki) * skala);
    trzyde.line(((cel_x + x_do_celu/10000.) + x_strzalki) * skala, ((cel_y + (y_do_celu/10000.)) + y_strzalki) * skala, 0, ((cel_x + x_do_celu/10000.) + x_strzalki) * skala, ((cel_y + (y_do_celu/10000.)) + y_strzalki) * skala, wysokosc/wspolczynnik_wysokosci);
    */
    
    
    
  
    //Wypisywanie zmiennych po prawej
    
    if(stronaZmiennych == 0)
    {
        pokaz_zmienna_po_prawej("Right link ", (linka_P/100.), 0);
        pokaz_zmienna_po_prawej("Left link ", (linka_L/100.), 35);
        pokaz_zmienna_po_prawej("Distance to target ", odleglosc_od_celu, 70);
        pokaz_zmienna_po_prawej("Wind x ", LIN_wiatr_x/1000., 105);
        pokaz_zmienna_po_prawej("Wind y ", LIN_wiatr_y/1000., 140);
        pokaz_zmienna_po_prawej("Height ", wysokosc, 175);
        pokaz_zmienna_po_prawej("Minutes x ", wejscie_minuty_x/100000., 210);
        pokaz_zmienna_po_prawej("Minutes y ", wejscie_minuty_y/100000., 245);
        pokaz_zmienna_po_prawej("Algorithm: ", faza_algorytmu, 280); //Simple to the point, Air traffic pattern, Calculating the wind
        //pokaz_zmienna_po_prawej("Target x ", cel_x, 315);
    }
    else if(stronaZmiennych == 1)
    {
        pokaz_zmienna_po_prawej("LIN_i ", LIN_i, 0);
        pokaz_zmienna_po_prawej("restart ", restart, 35);
        pokaz_zmienna_po_prawej("blisko_celu ", blisko_celu, 70);
        pokaz_zmienna_po_prawej("FPS ", (int)frameRate, 105);
        pokaz_zmienna_po_prawej("Wielkość tablic ", dane_azymut.length, 140);
        
        pokaz_zmienna_po_prawej("x_wiatr_zielony ", x_wiatr_zielony[x_wiatr_zielony.length - 1], 175);
        pokaz_zmienna_po_prawej("y_wiatr_zielony ", y_wiatr_zielony[y_wiatr_zielony.length - 1], 210);
        pokaz_zmienna_po_prawej("x_wiatr_fioletowy ", x_wiatr_fioletowy[x_wiatr_fioletowy.length - 1], 245);
        pokaz_zmienna_po_prawej("y_wiatr_fioletowy ", y_wiatr_fioletowy[y_wiatr_fioletowy.length - 1], 280);
        
        //pokaz_zmienna_po_prawej("rysowany_x ", rysowany_x, 175);
        //pokaz_zmienna_po_prawej("rysowany_y ", rysowany_y, 210);
        
        //pokaz_zmienna_po_prawej("Target x ", cel_x, 70);
        //pokaz_zmienna_po_prawej("Target y ", cel_y, 105);
        
        //dane testowe
        //pokaz_zmienna_po_prawej("x_strzalki ", x_strzalki, 385);
        //pokaz_zmienna_po_prawej("y_strzalki ", y_strzalki, 420);
        //pokaz_zmienna_po_prawej("Cele zapasowe x ", cele_zapasowe_x[0], 350);
        //pokaz_zmienna_po_prawej("Cele zapasowe y ", cele_zapasowe_y[0], 385);
        //pokaz_zmienna_po_prawej("Blisko celu", blisko_celu, 420);
        //pokaz_zmienna_po_prawej("Dane_przesuniecie ", dane_przesuniecie[dane_przesuniecie.length - 1], 455);
    }
    else if(stronaZmiennych == 2)
    {
        //1
        noStroke();     
        if(czyRysowacOdczytyWiatru == true)
        {
            image(checkboxPrawda, trzyde.width + 15, 15, 40, 40);
        }
        else
        {
            image(checkboxFalsz, trzyde.width + 15, 15, 40, 40);            
        }

        stroke(255);                                           //kolor obramowania (biały)
        textSize(24);                                          //grubość czcionki
        fill(0, 102, 153);                                     //wypełnienie (niebieski)
        textAlign(LEFT);
        //text("- Odczyty wiatru", trzyde.width + 70, 45);             //pokaż wartość
        text("- Wind readings", trzyde.width + 70, 45);             
        textAlign(RIGHT);
        
        
        //2
        noStroke();     
        if(czyRysowacZielonaLinie == true)
        {
            image(checkboxPrawda, trzyde.width + 15, 70, 40, 40);
        }
        else
        {
            image(checkboxFalsz, trzyde.width + 15, 70, 40, 40);            
        }

        stroke(255);                                           //kolor obramowania (biały)
        textSize(24);                                          //grubość czcionki
        fill(0, 102, 153);                                     //wypełnienie (niebieski)
        textAlign(LEFT);
        //text("- Zielona linia", trzyde.width + 70, 100);             //pokaż wartość
        text("- Green line", trzyde.width + 70, 100);             
        textAlign(RIGHT);
        
    }
    else if(stronaZmiennych == 3)
    {
        textAlign(LEFT);
        
        text("x", 10000, 40);  //bez tego nie działa
        
        //1 (Zielona stałka - Cansat)
        strokeWeight(4);
        stroke(102, 255, 102);
        
        line(trzyde.width + 30, 37, trzyde.width + 30, 23);
        line(trzyde.width + 30, 23, trzyde.width + 25, 28);
        line(trzyde.width + 30, 23, trzyde.width + 35, 28);
        
        strokeWeight(3);
        stroke(0, 102, 153);
        line(trzyde.width + 60, 30, trzyde.width + 70, 30);
        
        stroke(255);
        textSize(24);
        fill(0, 102, 153);
        text("CanSat", trzyde.width + 85, 40);
        
        //2 (Czerwona kropka - cel)
        strokeWeight(10);                                     
        stroke(255, 0, 0);                                    
        point(trzyde.width + 30, 70);
        
        strokeWeight(3);                                      
        stroke(0, 102, 153);                                  
        line(trzyde.width + 60, 70, trzyde.width + 70, 70);
        
        stroke(255);                                          
        textSize(24);                                         
        fill(0, 102, 153);
        text("Selected landing point", trzyde.width + 85, 80); 
        
        //3 (Półprzeźroczysta czerwona kropka - zapasowe cele)
        strokeWeight(10);                                     
        stroke(255, 0, 0, 127);                               
        point(trzyde.width + 30, 110);
        
        strokeWeight(3);                                      
        stroke(0, 102, 153);                                  
        line(trzyde.width + 60, 110, trzyde.width + 70, 110);
        
        stroke(255);                                          
        textSize(24);                                         
        fill(0, 102, 153);
        text("Spare landing points", trzyde.width + 85, 120);
        
        //4 (Fioletowy okrąg - teren gdzie może wylądować Cansat)
        strokeWeight(1);                                      
        stroke(190, 51, 255);                                 
        noFill();
        circle(trzyde.width + 30, 150, 20);
        
        strokeWeight(3);                                      
        stroke(0, 102, 153);                                  
        line(trzyde.width + 60, 150, trzyde.width + 70, 150);
        
        stroke(255);                                          
        textSize(24);                                         
        fill(0, 102, 153);
        text("Area where CanSat", trzyde.width + 85, 160);
        text("can land", trzyde.width + 85, 200);
        
        
        //5 (Niebieski okrąg - teren gdzie powinien wylądować Cansat)
        strokeWeight(1);                                      //grubośc
        stroke(7, 219, 219);
        noFill();
        circle(trzyde.width + 30, 230, 20);
        
        strokeWeight(3);                                      //grubośc
        stroke(0, 102, 153);                                  //kolor obramowania (czerwony)
        line(trzyde.width + 60, 230, trzyde.width + 70, 230);
        
        stroke(255);                                          //kolor obramowania (biały)
        textSize(24);                                         //grubość czcionki
        fill(0, 102, 153);
        text("Area where CanSat", trzyde.width + 85, 240);
        text("should land", trzyde.width + 85, 280);
        
        
        textAlign(RIGHT);
    }
    else if(stronaZmiennych == 4)
    {
        textAlign(LEFT);
        
        text("x", 10000, 40); //bez tego nie działa
        
        //1 (Zielona kreska - właściwy wiatr)
        strokeWeight(2);
        stroke(0, 255, 0);
        noFill();
        line(trzyde.width + 20, 20, trzyde.width + 40, 40);
        
        strokeWeight(3);                                      
        stroke(0, 102, 153);                                  
        line(trzyde.width + 60, 30, trzyde.width + 70, 30);
        
        stroke(255);                                          
        textSize(24);                                         
        fill(0, 102, 153);
        text("Simulated wind", trzyde.width + 85, 40);
        
        //2 (Różowa kreska - obliczony wiatr)
        strokeWeight(2);                                      
        stroke(255, 105, 180);
        noFill();
        line(trzyde.width + 20, 60, trzyde.width + 40, 80);
        
        strokeWeight(3);                                      
        stroke(0, 102, 153);                                  
        line(trzyde.width + 60, 70, trzyde.width + 70, 70);
        
        stroke(255);                                          
        textSize(24);                                         
        fill(0, 102, 153);
        text("Calculated wind", trzyde.width + 85, 80);       

        //3 (Żółta półprzeźroczysta kropka - środek kamery)
        strokeWeight(10);
        stroke(255, 255, 0, 155);
        noFill();
        point(trzyde.width + 30, 110);
        
        strokeWeight(3);                                      
        stroke(0, 102, 153);                                  
        line(trzyde.width + 60, 110, trzyde.width + 70, 110);
        
        stroke(255);                                          
        textSize(24);                                         
        fill(0, 102, 153);
        text("Camera center point", trzyde.width + 85, 120);
        
        //4 (różowa kreska - trasa 3D cansata)
        strokeWeight(2);                                      
        stroke(255, 155, 155);
        noFill();
        line(trzyde.width + 20, 140, trzyde.width + 40, 160);
        
        strokeWeight(3);                                      
        stroke(0, 102, 153);                                  
        line(trzyde.width + 60, 150, trzyde.width + 70, 150);
        
        stroke(255);                                          
        textSize(24);                                         
        fill(0, 102, 153);
        text("CanSat's Trace 3D", trzyde.width + 85, 160);
        
        //5 (żółta kreska - trasa 2D cansata)
        strokeWeight(2);                                      
        stroke(255, 255, 0);
        noFill();
        line(trzyde.width + 20, 180, trzyde.width + 40, 200);
        
        strokeWeight(3);                                      
        stroke(0, 102, 153);                                  
        line(trzyde.width + 60, 190, trzyde.width + 70, 190);
        
        stroke(255);                                          
        textSize(24);                                         
        fill(0, 102, 153);
        text("CanSat's Trace 2D", trzyde.width + 85, 200);
        
        //6 (żółta kreska - linie pomocnicze)
        strokeWeight(2);                                      
        stroke(255, 0, 255);
        noFill();
        line(trzyde.width + 20, 220, trzyde.width + 40, 240);
        
        strokeWeight(3);                                      
        stroke(0, 102, 153);                                  
        line(trzyde.width + 60, 230, trzyde.width + 70, 230);
        
        stroke(255);                                          
        textSize(24);                                         
        fill(0, 102, 153);
        text("Support line", trzyde.width + 85, 240);
        
        
        textAlign(RIGHT);
    }
}

void rysujPrzyciski()
{
    noStroke();     
    image(przyciskLewo, 1020, 352, 40, 40);
    image(przyciskPrawo, 1078, 352, 40, 40);
    
    if(pauza == true)
    {
        if (zapisano == 0) 
        {                
            image(przyciskDownload, 1136, 352, 40, 40);
        }
        else 
        {
            image(przyciskDownload, 1141, 357, 30, 30);
        }
        image(przyciskUpload, 1194, 352, 40, 40);
    }
    
    //przycisk pauza
    if(pauza == false)                 //jak pauza jest włączona
        image(przyciskPauza, 1252, 352, 40, 40);
    else
        image(przyciskPlay, 1252, 352, 40, 40);
    
    image(przyciskRestart, 1310, 352, 40, 40);
}

void rysujWersjeSymulatora()
{
    strokeWeight(1);
    fill(0, 102, 153);
    textSize(40);
    text("Flight Algorithm Simulator " + wersja, 735, 750);
}

void mapaWiatru()
{
    strokeWeight(2.5);                        //grubość
    stroke(255, 255, 255, 255);               //kolor obramowania (biały)          nieprzeźroczysty
    
    line(1010, 412, 1366, 412);               //linie obramowania wiatru
    line(1010, 412, 1010, 768);               //
    
    strokeWeight(1);
    stroke(255, 0, 0, 80);                    //kolor obramowania (czerwony)       trochę przeźroczyste
    for(int x = 20; x < 356; x += 20)         //pionowe
        line(1010 + x, 414, 1010 + x, 768);   //
     
    for(int y = 20; y < 356; y += 20)         //pioziome
        line(1010, 413 + y, 1366, 413 + y);   //
    
    //zaznaczanie pola wiatru
    strokeWeight(2);            //grubość                   
    
    stroke(100, 100, 100);      //kolor obramowania (szary)
    noFill();
  
    if(kursor_jest_na_mapie_wiatru(mouseX, mouseY) && pole_wiatru_w_trakcie_zaznaczania == true)
    {
        rect(
            map(x_wiatr.granica_zakresu1, -90, 90, 1010, 1366),                                                         //  koordynaty pierwszego rogu
            map(y_wiatr.granica_zakresu1, -90, 90, 412, 768),                                                           //
            mouseX - map(x_wiatr.granica_zakresu1, -90, 90, 1010, 1366),                                                //  szerokość i wysokość prostokąta
            mouseY - map(y_wiatr.granica_zakresu1, -90, 90, 412, 768)                                                 //
        ); 
    }
    else if(pole_wiatru_w_trakcie_zaznaczania == false)
    {  
        rect(
            map(x_wiatr.granica_zakresu1, -90, 90, 1010, 1366),                                                         //  koordynaty pierwszego rogu
            map(y_wiatr.granica_zakresu1, -90, 90, 412, 768),                                                           //
            map(x_wiatr.granica_zakresu2, -90, 90, 1010, 1366) - map(x_wiatr.granica_zakresu1, -90, 90, 1010, 1366),    //  szerokość i wysokość prostokąta
            map(y_wiatr.granica_zakresu2, -90, 90, 412, 768) - map(y_wiatr.granica_zakresu1, -90, 90, 412, 768)     //
        );  
    }
    
    //rysowanie wektora wiatru 
    strokeWeight(2);          //grubośc
    stroke(0, 255, 0);        //kolor obramowania (zielony)
    line(map(x_wiatr.wiatr, -90, 90, 1010, 1366), map(y_wiatr.wiatr, -90, 90, 412, 768), 1188, 591);
    
    if(restart > 0)
    {
        restart--;
    }
    else
    {
        //rysowanie wektora wiatru obliczonego
        stroke(255, 105, 180);    //kolor obramowania (różowy)
        line(map(LIN_wiatr_x/1000. * 98, -90, 90, 1010, 1366), map(LIN_wiatr_y/1000. * 98, -90, 90, 412, 768), 1188, 591);
    }
}

void Minuty()
{
    if(pauza == false && nowa_symulacja == false)            //jeżeli nie ma pauzy
    {
        wejscie_minuty_x = (int) (100000 * ((kursor_pocz_x + rysowany_x - cel_x + cel_x) / 1170 + 30));  //obliczanie gdzie jest cansat w stopniach geograficznych
        wejscie_minuty_y = (int) (100000 * (51 - (kursor_pocz_y - rysowany_y - cel_y + cel_y) / 1852));
    }
}

void algorytm_i_Tablice()
{
    if(pauza == false && nowa_symulacja == false)            //jeżeli nie ma pauzy
    {
        aktualny_azymut = (short) (dane_azymut[dane_azymut.length - 1]);               //zczytywanie z tablicy ostatniego azymutu cansata
        
        cansat();              //uruchomienie funkcji, która będzie w mikrokontrolerze w Cansacie
                               //uruchamia algorytm, steruje on gdzie ma polecieć cansat - obraca linkami 
          
        //obliczanie azymutu wiatru
        if(x_wiatr.wiatr != 0)
        {
            azymut_wiatru = abs(degrees(atan(abs((float) y_wiatr.wiatr) / abs((float) x_wiatr.wiatr))));
            
            if(x_wiatr.wiatr<=0 &&  y_wiatr.wiatr<=0)
                azymut_wiatru = (450 + azymut_wiatru) % 360;
                
            else if(x_wiatr.wiatr>=0 && y_wiatr.wiatr<=0)
                azymut_wiatru = 270 - azymut_wiatru;
                
            else if(x_wiatr.wiatr>=0 && x_wiatr.wiatr>=0)
                azymut_wiatru = 270 + azymut_wiatru;
                
            else if(x_wiatr.wiatr<=0 && y_wiatr.wiatr>=0)
                azymut_wiatru = (450 - azymut_wiatru) % 360;
              
            azymut_wiatru = (azymut_wiatru + 180) % 360;
        }
          
        //dodawanie do tablic zmiennych na ostatnie miejsce
        azymut_wiatru_tablica = append(azymut_wiatru_tablica, azymut_wiatru);
        
        dane_azymut =           append(dane_azymut, (dane_azymut[dane_azymut.length - 1] + ((linka_P/100.) - (linka_L/100.)) * wspolczynnik_obrotu) % 360);                //każdorazowa zmiana kąta w stopniach
        while(dane_azymut[dane_azymut.length - 1] < 0)
        {
            dane_azymut[dane_azymut.length - 1] += 360;
        }
        
        sila_wiatru = sqrt(sq(x_wiatr.wiatr) + sq(y_wiatr.wiatr)) / 110;     //obliczanie sily wiatru
        
        sila_wiatru_tablca =    append(sila_wiatru_tablca, sila_wiatru);
        
        x_wiatr_zielony =       append(x_wiatr_zielony, x_wiatr.wiatr);
        y_wiatr_zielony =       append(y_wiatr_zielony, y_wiatr.wiatr);
        x_wiatr_fioletowy =     append(x_wiatr_fioletowy, LIN_wiatr_x/1000. * 98);
        y_wiatr_fioletowy =     append(y_wiatr_fioletowy, LIN_wiatr_y/1000. * 98);
        
        dane_przesuniecie =     append(dane_przesuniecie, szybkosc_cansata / 5);    //szybkosc cansata * 1/5 
        
        
        //opadanie cansata
        if(wysokosc > 0)                               //jeżeli jeszcze cansat nie opadł
        {
            wysokosc -= szybkosc_opadania / 5;         //szybkosc_opadania * 1/5
        }
        else
        {
            pauza = true;                              //jeżeli cansat opadł zatrzymaj program (włącz pauzę)
        }
            
        dane_wysokosc =         append(dane_wysokosc, wysokosc);
         
        //obliczanie losowego wiatru
        x_wiatr.update();
        y_wiatr.update();
        
        dane_wiatr_x =          append(dane_wiatr_x, x_wiatr.wiatr);
        dane_wiatr_y =          append(dane_wiatr_y, y_wiatr.wiatr);
    }
}
////////////////////////////////////////////////////ZAMKNIECIE 3D//////////////////////////////

void zamkniecie3D()
{
    trzyde.popMatrix();
    trzyde.endDraw();                                    // koniec rysowania 3d
    image(trzyde, trzyde_x, trzyde_y);                   //
}


////////////////////////////////////////////////////MINI CANSAT//////////////////////////////

void miniCansat()
{
    //mały CanSat
    mini.beginDraw();                                  
    mini.lights();                                     
    mini.background(0);                                
    minicansat.update();                                 
    mini.pushMatrix();
    mini.rotateZ(radians(180));
    mini.rotateY(radians(dane_azymut[dane_azymut.length - 1] - 90));
    mini.shape(puszka, 0, 0); 
    mini.popMatrix();
    mini.endDraw();                                    
    image(mini, mini_x, mini_y);
    strokeWeight(2.5);
    stroke(255);
    noFill();
    rect(mini_x, mini_y, mini.width, mini.height);
}

void rysujPunktKamery()
{
    //żółta kropka kamery
    fill(255, 255, 0, 155);
    strokeWeight(0);
    circle(trzyde_x + trzyde.width / 2, trzyde_y + trzyde.height / 2, 5000 / camera.dist);
}

String zeraPoprzedzajace(int liczba)
{
    if(liczba < 10)
    {
        return "0" + str(liczba);
    }
    else
    {
        return str(liczba);
    }
}

////////////////////////////////////////////////////ZEROWANIE ZMIENNYCH//////////////////////////////

void zerowanieZmiennych()
{
    //ustawia wszystkie zmienne na takie jakie były na początku
         
    pauza = false;
    Powtorka = false;    
    
    wysokosc = 3000;                       
    czy_szukac_innego_celu = 1;            
    
    
    kursor_pocz_x = random(440 / skala, 880 / skala);
    kursor_pocz_y = random(440 / skala, 880 / skala);
    cel_x = 2008.5000000390;
    cel_y = 1821.1333332716;
    
    pole_wiatru_w_trakcie_zaznaczania = false;
    
    wejscie_minuty_x = 0;
    wejscie_minuty_y = 0;
    
    azymut_wiatru = 0;
    sila_wiatru = 1;
    
    linka_P = 0;
    linka_L = 0;
    
    rysowany_x = 0;
    rysowany_y = 0;
    
    aktualny_azymut = 0;
    
    blisko_celu = 0;

    odleglosc_od_celu = 0;
    
    zerowanieTablic();           
    
    LIN_wiatr_x = 0;
    LIN_wiatr_y = 0;
    
    restart = 2000;
    nowa_symulacja = true;
    
    x_wiatr.restart();
    y_wiatr.restart();
    
    restartKML();
}

void zerowanieTablic()
{
    //zerowanie tablic
    float[] tablica_zerujaca = {0};
    dane_azymut =           tablica_zerujaca;    
    dane_przesuniecie =     tablica_zerujaca; 
    dane_wiatr_x =          tablica_zerujaca;            
    dane_wiatr_y =          tablica_zerujaca;
    azymut_wiatru_tablica = tablica_zerujaca; 
    sila_wiatru_tablca =    tablica_zerujaca;
    x_teraz =               tablica_zerujaca;           
    y_teraz =               tablica_zerujaca;           
    dane_wysokosc =         tablica_zerujaca;
    
    x_wiatr_zielony =       tablica_zerujaca;                
    y_wiatr_zielony =       tablica_zerujaca;                
    x_wiatr_fioletowy =     tablica_zerujaca;              
    y_wiatr_fioletowy =     tablica_zerujaca; 
}
