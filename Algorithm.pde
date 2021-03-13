//Robimy inty zamiast float
//współrzędne robimy 4 miejsca po przecinku - czyli dokładność GPS około 0.2m (int -> long)
//azymuty robimy 2 miejsca po przecinku (short -> int)
//(byte -> char)

//mpp = miejsca po przecinku 

int x_do_celu;  //4 mpp       //odległość cansata od celu
int y_do_celu;  //4 mpp       //


short KON_zakret = 0;  //stopnie od punktu do azymutu cansata od 0 do 179
short KON_azymut = 0;  //od 0 do 359 stopni


short KRO_azymut = 0;  //od 0 do 359 stopni
short KRO_zakret = 0;  //stopnie od punktu do azymutu cansata od 0 do 179
boolean KRO_etap = false;                //false - leci w stronę przeciwną niż punkt; true - leci w stronę punktu
boolean KRO_po_zakrecie = false;

short KRO_ile_metrow = 0;             //ilość metrów na 10 sekund ile cansat musi mieć żeby zmierzył wiatr 2 razy


byte LIN_licznik = 49;    //zmienna odliczająca 10s

short LIN_azymut = 0;  //od 0 do 359 stopni
short LIN_zakret = 0;  //stopnie od punktu do azymutu cansata od 0 do 179
int LIN_x_pocz = x_do_celu;  //początkowa pozycja cansata
int LIN_y_pocz = y_do_celu;  //początkowa pozycja cansata
short LIN_wiatr_x = 0;  //3 mpp  zakres od 0 do 1
short LIN_wiatr_y = 0;  //3 mpp
int LIN_odleglosc = 0;  //4 mpp

int LIN_i = 1;  //zmienne do wybierania nowego celu żeby cansat od razu do nich leciał a nie do starego celu
int LIN_j = 2;  //

int x1 = 0;  //4 mpp       //zmienne służące do obliczania przewidywanego wiatru
int y1 = 0;  //4 mpp 
int x2 = 0;  //4 mpp 
int y2 = 0;  //4 mpp 


int granica_zmian = 270;    //metry od których cansat może szukać celów zapasowych, gdy obliczy że nie doleci do celu głównego

int x_srodka_okregu = 0;                  //4 mpp      //x i y środka okręgu wyznaczającego obszar do którego CanSat może dolecieć
int y_srodka_okregu = 0;                  //4 mpp      //
int odleglosc_srodka_okregu_do_celu = 0;  //4 mpp      //odległość środka okręgu do celu
int promien_okregu = 0;                   //4 mpp      //promień fioletowego okręgu 

boolean CEL_czy_jest_jakis_punkt = false;  //zmienne do szukania najbliższych zapasowych punktów do których cansat może dolecieć 
byte CEL_najblizszy_punkt = 0;             //


void cansat()
{
    x_do_celu = int(10000 * (1170 * (wejscie_minuty_x/100000. - 30) - cel_x));  //ustawianie odległości miedzy cansatem a celem w osi x i y (w metrach)
    y_do_celu = int(10000 * (1852 * (51 - wejscie_minuty_y/100000.) - cel_y));  //
    
    cele();  //wywołuje funkcję cele, która sprawdza czy cansat doleci do swojego głównego celu
             //a jeśli obliczy że nie doleci to szuka najbliższego celu zapasowego do którego cansat może dolecieć
    
    odleglosc_od_celu = sqrt(sq(x_do_celu/10000.) + sq((y_do_celu/10000.)));             //oblicz odległość od celu w lini prostej (pitagoras)
    
    
    x2 = int(10000 * ((LIN_x_pocz/10000.) + cel_x + sin(radians(LIN_azymut)) * 11.2 * szybkosc_cansata));    //obliczanie x i y w jakim cansat miałyby by się znajdować po 10s gdyby nie było wiatru 
    y2 = int(10000 * ((LIN_y_pocz/10000.) + cel_y - cos(radians(LIN_azymut)) * 11.2 * szybkosc_cansata));    //1.2*0.8*5*10=48  48/10+4*10=44.8 44.8/4=11.2
    
    if(odleglosc_od_celu < srednia_celu)       //jeżeli jest w punkcie
    {
        blisko_celu = 2;                 //zmienia algorytm na kręgi nadlotniskowe
        czy_szukac_innego_celu = 0;      //nie szuka już nowych punktów
    }
    
    
    if(wysokosc <= ostatnia_wysokosc)    //jeżeli jest bardzo nisko (blisko ziemi)
    {
        koncowy_algorytm();              //uruchamiany jest algorytm lecenia wprost na cel
        faza_algorytmu = "Simple to the point";
    }
    else if(blisko_celu >= 2)            //jeżeli włączony jest algorytm kręgów nadlotniskowych
    {
        kregi();                         //uruchamiany jest algorytm kręgów nadlotniskowych
        faza_algorytmu = "Air traffic pattern";
    }
    else if(odleglosc_od_celu <= srednica_kola / 2)     //jeżeli jest w kole leci wprost na punkt
    {
        blisko_celu = 1;                 //włącza algorytm lecenia wprost na cel
        koncowy_algorytm();              //uruchamiany jest algorytm lecenia wprost na cel
        faza_algorytmu = "Simple to the point";
    }
    else
    {
        blisko_celu = 0;                //włącza algorytm przewidywania wiatru i stawiania się pod niego
        cansat_magnetometr();           ///uruchamiany jest algorytm przewidywania wiatru i stawiania się pod niego    
        faza_algorytmu = "Calculating the wind";
    }
    
}

//------------------------------------------------------------------------------------------------------
    
//będzie zataczał kółka nad celem aż wysokosc spadnie na 0
void koncowy_algorytm()
{
    //oblicza azymut
    KON_azymut = (short) abs(degrees(atan((y_do_celu/10000.) / (x_do_celu/10000.))));
             
    if(x_do_celu<=0 && (y_do_celu/10000.)<=0)
    {
        KON_azymut = (short) ((450 + KON_azymut) % 360);
    }
    else if(x_do_celu>=0 && (y_do_celu/10000.)<=0)
    {
        KON_azymut = (short) (270 - KON_azymut);
    }
    else if(x_do_celu>=0 && (y_do_celu/10000.)>=0)
    {
        KON_azymut = (short) (270 + KON_azymut);
    }
    else if(x_do_celu<=0 && (y_do_celu/10000.)>=0)
    {
        KON_azymut = (short) ((450 - KON_azymut) % 360);
    }
    
    //skręca w lewo lub w prawo zależnie od tego gdzie jest skierowany
    if(KON_azymut > 180)
    {
        if(aktualny_azymut < KON_azymut - 180 || aktualny_azymut > KON_azymut)
        {
            if(aktualny_azymut > KON_azymut)
                KON_zakret = (short) (KON_azymut - aktualny_azymut);
            else
                KON_zakret = (short) (KON_azymut - 360 - aktualny_azymut);
        }
        else
        {
            KON_zakret = (short) (KON_azymut - aktualny_azymut);
        }
    }
    else
    {
        if(aktualny_azymut > KON_azymut + 180 || aktualny_azymut < KON_azymut)
        {  
            if(aktualny_azymut < KON_azymut)
                KON_zakret = (short) (KON_azymut - aktualny_azymut);
            else
                KON_zakret = (short) (360 - aktualny_azymut + KON_azymut);
        }
        else
        {
            KON_zakret = (short) (KON_azymut - aktualny_azymut);
        }
    }
    
    //żeby nie myszkował - tylko leciał prosto
    if(abs(KON_zakret) > 3)  
    {  
        if(abs(9.25 * ((linka_P/100.) - (linka_L/100.))) < abs(KON_zakret))
        {
            if(KON_zakret > 0)
            {
                obrot_linek_w_prawo();
            }
            else
            {
                obrot_linek_w_lewo();
            }
        }
        else
        {
            if(KON_zakret < 0)
            {
                obrot_linek_w_prawo();
            }
            else
            {
                obrot_linek_w_lewo();
            }
        }
    }
    else
    {
        //zmienia linki
        if(((linka_P/100.) - (linka_L/100.)) > 0)
        {
            obrot_linek_w_lewo();
        }
        else if(((linka_P/100.) - (linka_L/100.)) < 0)
        {
            obrot_linek_w_prawo();
        }
    }
    
    //sprawdza czy linki nie wychodzą poza skalę
    //sprawdza czy tylko jedna linka jest pociągnięta
    if((linka_P/100.) > 2)  
        linka_P = 2*100;
    else if((linka_P/100.) < 0)  
        linka_P = 0;
    
    if((linka_L/100.) > 2)
        linka_L = 2 * 100;
    else if((linka_L/100.) < 0)
        linka_L = 0;
}

//------------------------------------------------------------------------------------------------------

void kregi()  //kręgi nadlotniskowe
{
    if (KRO_etap == false)
    {
        
        if(LIN_wiatr_x == 0) LIN_wiatr_x++;
        
        //oblicza azymut
        KRO_azymut = (short) ((abs(degrees(atan(  LIN_wiatr_y / LIN_wiatr_x))) + 180) % 360);
                 
        if(LIN_wiatr_x<=0 && LIN_wiatr_y<=0)
        {
            KRO_azymut = (short) ((450 + KRO_azymut) % 360);
        }
        else if(LIN_wiatr_x>=0 && LIN_wiatr_y<=0)
        {
            KRO_azymut = (short) (270 - KRO_azymut);
        }
        else if(LIN_wiatr_x>=0 && LIN_wiatr_y>=0)
        {
            KRO_azymut = (short) (270 + KRO_azymut);
        }
        else if(LIN_wiatr_x<=0 && LIN_wiatr_y>=0)
        {
            KRO_azymut = (short) ((450 - KRO_azymut) % 360);
        }
        
        //skręca w lewo lub w prawo zależnie od tego gdzie jest skierowany
        if(KRO_azymut > 180)
        {
            if(aktualny_azymut < KRO_azymut - 180 || aktualny_azymut > KRO_azymut)
            {
                if(aktualny_azymut > KRO_azymut)
                    KRO_zakret = (short) (KRO_azymut - aktualny_azymut);
                else
                    KRO_zakret = (short) (KRO_azymut - 360 - aktualny_azymut);
            }
            else
            {
                KRO_zakret = (short) (KRO_azymut - aktualny_azymut);
            }
        }
        else
        {
            if(aktualny_azymut > KRO_azymut + 180 || aktualny_azymut < KRO_azymut)
            {  
                if(aktualny_azymut < KRO_azymut)
                    KRO_zakret = (short) (KRO_azymut - aktualny_azymut);
                else
                    KRO_zakret = (short) (360 - aktualny_azymut + KRO_azymut);
            }
            else
            {
                KRO_zakret = (short) (KRO_azymut - aktualny_azymut);
            }
        }
        
        //żeby nie myszkował - tylko leciał prosto
        if(abs(KRO_zakret) > 3)  
        {  
            if(abs(9.25 * ((linka_P/100.) - (linka_L/100.))) < abs(KRO_zakret))
            {
                if(KRO_zakret > 0)
                {
                    obrot_linek_w_prawo();
                }
                else
                {
                    obrot_linek_w_lewo();
                }
            }
            else
            {
                if(KRO_zakret < 0)
                {
                    obrot_linek_w_prawo();
                }
                else
                {
                    obrot_linek_w_lewo();
                }
            }
        }
        else
        {
            if(((linka_P/100.) - (linka_L/100.)) > 0)
            {
                obrot_linek_w_lewo();
            }
            else if(((linka_P/100.) - (linka_L/100.)) < 0)
            {
                obrot_linek_w_prawo();
            }
        }
        
        if(1 - sqrt(sq(LIN_wiatr_x/1000.) + sq(LIN_wiatr_y/1000.)) < 0.1)
            KRO_ile_metrow = (short) (10 * 5 * dane_przesuniecie[dane_przesuniecie.length - 1] * 0.1 * 2.5);
        else
            KRO_ile_metrow = (short) (10 * 5 * dane_przesuniecie[dane_przesuniecie.length - 1] * (1 - sqrt(sq(LIN_wiatr_x/1000.) + sq(LIN_wiatr_y/1000.))) * 2.5);
            
        
        
        
        if(odleglosc_od_celu > srednica_kola / 2 * 1.5 + KRO_ile_metrow || promien_okregu/10000. / 1.2 < odleglosc_srodka_okregu_do_celu/10000.)
        {
            KRO_etap = true;
            LIN_licznik = 49;
            LIN_i = 1;
            LIN_j = 2;
        }
    }
    else if (KRO_etap == true)
    {
        if(odleglosc_od_celu <= srednica_kola / 2)
            koncowy_algorytm();
        else
            cansat_magnetometr();
        
        if(LIN_i == 0)
        KRO_po_zakrecie = true;
        
        if( (x_do_celu/10000. <=  10 && x_do_celu/10000. >=  -10 && (y_do_celu/10000.) <=  10 && (y_do_celu/10000.) >= -10) || (abs(LIN_zakret) > 70 && KRO_po_zakrecie == true))
        {
            KRO_etap = false;
            KRO_po_zakrecie = false;
        }
    }
    
    //sprawdza czy linki nie wychodzą poza skalę
    //sprawdza czy tylko jedna linka jest pociągnięta
    if((linka_P/100.) > 2)
        linka_P = 2*100;
    else if((linka_P/100.) < 0)  
        linka_P = 0;
    
    if((linka_L/100.) > 2)
        linka_L = 2*100;
    else if((linka_L/100.) < 0)
        linka_L = 0;
}

//------------------------------------------------------------------------------------------------------

void obrot_linek_w_prawo()
{
    linka_L -= obrot_linek*2*100;
    if((linka_L/100.) < 0)
    {
        linka_P -= linka_L;  //l=0
        linka_L = 0;
    }
}

void obrot_linek_w_lewo()
{
    linka_P -= obrot_linek*2*100;
    if((linka_P/100.) < 0)
    {
        linka_L -= linka_P;  //l=0
        linka_P = 0;
    }
}

void cansat_magnetometr()  //obliczenia działają tak samo jak w kręgach nadlotniskowych i końcowym algorytmie
{
 
    LIN_licznik++;
    if(LIN_licznik >= 50)
    {
      
      
        addCoordinates((wejscie_minuty_y/100000./60)+51,(wejscie_minuty_x/100000./60)+16, (int)wysokosc);
        
      
      
        x1 = int(10000 * (cel_x + x_do_celu/10000.));
        y1 = int(10000 * (cel_y + y_do_celu/10000.));
        
        if(LIN_i == 1)
        {
            if(LIN_j == 0) LIN_i = 0;
            x2 = int(10000 * (cel_x + x_do_celu/10000.));
            y2 = int(10000 * (cel_y + y_do_celu/10000.));
        }
        else
        {
            if(1000 * (x1/10000. - x2/10000.) / 50 > 1200)
                LIN_wiatr_x = 1200;
            else if(1000 * (x1/10000. - x2/10000.) / 50 < -1200)
                LIN_wiatr_x = -1200;
            else
                LIN_wiatr_x = (short) (1000 * (x1/10000. - x2/10000.) / 50);
            
            if(1000 * (y2/10000. - y1/10000.) / -50 > 1200)
                LIN_wiatr_y = 1200;
            else if(1000 * (y2/10000. - y1/10000.) / -50 < -1200)
                LIN_wiatr_y = -1200;
            else
                LIN_wiatr_y = (short) (1000 * (y2/10000. - y1/10000.) / -50);
        }
        
       
        LIN_odleglosc = int( 10000 * sqrt(x_do_celu/10000. * x_do_celu/10000. + (y_do_celu/10000.) * (y_do_celu/10000.)));
        
        LIN_azymut =  (short) (abs(degrees(atan(  ((y_do_celu/10000.) + LIN_wiatr_y/1000. * LIN_odleglosc/10000.) / (x_do_celu/10000. + LIN_wiatr_x/1000. * LIN_odleglosc/10000.)))));
        
        if(x_do_celu<=0 && (y_do_celu/10000.)<=0)
        {
            LIN_azymut = (short) ((450 + LIN_azymut) % 360);
        }
        else if(x_do_celu>=0 && (y_do_celu/10000.)<=0)
        {
            LIN_azymut = (short) (270 - LIN_azymut);
        }
        else if(x_do_celu>=0 && (y_do_celu/10000.)>=0)
        {
            LIN_azymut = (short) (270 + LIN_azymut);
        }
        else if(x_do_celu<=0 && (y_do_celu/10000.)>=0)
        {
            LIN_azymut = (short) ((450 - LIN_azymut) % 360);
        }
        
        
        LIN_x_pocz = x_do_celu;
        LIN_y_pocz = y_do_celu;
        
        
        
        
        LIN_licznik = 0;    
    }
    
       
    
    if(LIN_azymut > 180)
    {
        if(aktualny_azymut < LIN_azymut - 180 || aktualny_azymut > LIN_azymut)
        {
            if(aktualny_azymut > LIN_azymut)
                LIN_zakret = (short) (LIN_azymut - aktualny_azymut);
            else
                LIN_zakret = (short) (LIN_azymut - 360 - aktualny_azymut);
        }
        else
        {
            LIN_zakret = (short) (LIN_azymut - aktualny_azymut);
        }
    }
    else
    {
        if(aktualny_azymut > LIN_azymut + 180 || aktualny_azymut < LIN_azymut)
        {
            if(aktualny_azymut < LIN_azymut)
                LIN_zakret = (short) (LIN_azymut - aktualny_azymut);
            else
                LIN_zakret = (short) (360 - aktualny_azymut + LIN_azymut);
        }
        else
        {
            LIN_zakret = (short) (LIN_azymut - aktualny_azymut);
        }
    }
      
    if(abs(LIN_zakret) > 3)  
    {  
        if(abs(9.25 * ((linka_P/100.) - (linka_L/100.))) < abs(LIN_zakret))
        {
            if(LIN_zakret > 0)
            {
                obrot_linek_w_prawo();
            }
            else
            {
                obrot_linek_w_lewo();
            }
        }
        else
        {
            if(LIN_zakret < 0)
            {
                obrot_linek_w_prawo();
            }
            else
            {
               obrot_linek_w_lewo();
            }
        }
    }
    else
    {
        if(((linka_P/100.) - (linka_L/100.)) > 0)
        {
            obrot_linek_w_lewo();
        }
        else if(((linka_P/100.) - (linka_L/100.)) < 0)
        {
            obrot_linek_w_prawo();
        }
    }
    
    
    if((linka_P/100.) > 2)  
        linka_P = 2*100;
    else if((linka_P/100.) < 0)  
        linka_P = 0;
  
    if((linka_L/100.) > 2)
        linka_L = 2*100;
    else if((linka_L/100.) < 0)
        linka_L = 0;
        
    
        
    if(LIN_j > 0 && abs(LIN_zakret) < 3)
    {
        LIN_j --;
        LIN_i = 1;
        LIN_licznik = 49;
    }
}

//---------------------------------------------------------------------------------------------------------------------

void cele()
{
    if(wysokosc < granica_zmian)    //dopiero na odpowiedniej wysokości cansat może wybrać zapasowy cel gdy obliczy że nie doleci do głównego celu 
    {
        x_srodka_okregu = int(10000 * (cel_x + (x_do_celu/10000.) + wysokosc * szybkosc_cansata * 1.2 / szybkosc_opadania * LIN_wiatr_x/1000.));        //obliczanie x i y środka koła uwzględniając wiatr
        y_srodka_okregu = int(10000 * (cel_y + (y_do_celu/10000.) + wysokosc * szybkosc_cansata * 1.2 / szybkosc_opadania * LIN_wiatr_y/1000.));        //
        odleglosc_srodka_okregu_do_celu = int(10000 * (sqrt(sq(cel_x - x_srodka_okregu/10000.) + sq(cel_y - y_srodka_okregu/10000.))));       //odległość od środka koła do celu
        
        promien_okregu = int(10000 * wysokosc * szybkosc_cansata * 1.2 / szybkosc_opadania);      //4 * 1.2 / 3
        
        
        for(int i = 0; i < 5; i++)    //obliczanie odległości od celów zapasowych
        {
            odleglosci_zapasowe[i] = sqrt(sq(cele_zapasowe_x[i] / skala - (cel_x + x_do_celu/10000.)) + sq(cele_zapasowe_y[i] / skala - (cel_y + (y_do_celu/10000.))));
        }
        
        //sprawdzanie czy doleci do celu    jeżeli nie to sprawdza czy doleci do celów zapasowych i ustawia najbliższy jako główny
        if(czy_szukac_innego_celu == 1 && promien_okregu/10000. < odleglosc_srodka_okregu_do_celu/10000.)      
        {
            CEL_czy_jest_jakis_punkt = false; 
            CEL_najblizszy_punkt = 0;
            for(int i = 0; i < 5; i++)
            {
                if(promien_okregu/10000. > odleglosci_zapasowe[i])
                {    
                    if(CEL_czy_jest_jakis_punkt == false)
                        CEL_najblizszy_punkt = byte(i);
                        
                    CEL_czy_jest_jakis_punkt = true;
                    if(odleglosci_zapasowe[i] < odleglosci_zapasowe[CEL_najblizszy_punkt])
                        CEL_najblizszy_punkt = byte(i);
                }
            }
            
            if(CEL_czy_jest_jakis_punkt == true)
            {
                //zamienia cel główny z celem zapasowym
                int cel_x_zapasowe = int(10000*cel_x);
                int cel_y_zapasowe = int(10000*cel_y);
                cel_x = cele_zapasowe_x[CEL_najblizszy_punkt] / skala;
                cel_y = cele_zapasowe_y[CEL_najblizszy_punkt] / skala;
                cele_zapasowe_x[CEL_najblizszy_punkt] = cel_x_zapasowe/10000. * skala;
                cele_zapasowe_y[CEL_najblizszy_punkt] = cel_y_zapasowe/10000. * skala;
                LIN_i = 1;
                LIN_j = 2;
                LIN_licznik = 49;
                //rysuj_kolko = 0;
            }
            
        }  
    }
}
