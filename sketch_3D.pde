PGraphics trzyde;
int trzyde_x;
int trzyde_y;
eye camera = new eye();
PGraphics mini;
int mini_x;
int mini_y;
eye2 minicansat = new eye2();
movement mouse = new movement();

PShape puszka;

wiatr x_wiatr = new wiatr();
wiatr y_wiatr = new wiatr();

PImage przyciskDownload;
PImage przyciskUpload;
PImage przyciskPrawo;
PImage przyciskLewo;
PImage przyciskPauza;
PImage przyciskPlay;
PImage przyciskRestart;
PImage checkboxPrawda;
PImage checkboxFalsz;

////////////////////////////////////////////////////ZMIENNE///////////////////////////////

//na dole programu też trzeba przestawić zmienne
//Zmienne które będzie można łatwo zmieniać

final String wersja = "v.3.00";                    //wersja programu 

final int FPS = 30;                                //klatki na sekundę

final float obrot_linek = 0.07;                    //co 1/5 s
                                             
float wysokosc = 3000;                             //wysokość od ziemi (m)

final float szybkosc_cansata = 4;                  //szybkość cansata (m/s)
final float szybkosc_opadania = 3;                 //szybkość opadania (tracenia wysokości) (m/s)

final int srednica_kola = 200;                     //średnica koła w którym cansat leci wprost na punkt (m)
final byte srednia_celu = 10;                      //średnica koła w którym cansat musi wylądować (m)

final int ostatnia_wysokosc = 100;                 //wysokość po której cansat dąży do punktu nie zwracając uwagi na nic (m)

final float wspolczynnik_obrotu = 1.2;             //jak bardzo cansat się obraca (na razie nie przestawiać)

int czy_szukac_innego_celu = 1;                    //1-tak 0-nie

final int wspolczynnik_wysokosci = 3;              //skala wysokosci, jak wysoko widac cansata, musi byc od 1 do 6

final int dokladnoscRysowaniaSciezki = 10;         //łączenie określoną liczbę dokładności ścieżki żeby program był wydajniejszy
                                                   //1 - najdokładniejsze ale spowalnia program
                                                   //im większa dokładność tym program jest szybszy, ale trasa mniej dokładna
                                                   //przy 10 jest optymalnie - z daleka nie widać lini i jest szybki program

final int nerwowosc_wiatru = 30;                   //strowanie gwałtownością zmian wiatru; skala logarytmiczna 0 - 100
                                                   

//Koniec zmiennych które będzie można łatwo zmieniać

final float skala = 0.4;                     //nie zmieniać!
                                             //skala z jaką rysujemy wszystko na mapie
                                             //(1 px w symulatorze to 2 metry w rzeczywistości w skali 0.5)
                                             //(1 px w symulatorze to 1 metr w rzeczywistości w skali 1)
                                             //(1 px w symulatorze to 0.5 metra w rzeczywistości w skali 2) itd...


//(340 / skala x 1030 / skala), (850 x 2 575)
float kursor_pocz_x = random(440 / skala, 880 / skala);       //początkowa pozycja cansata (m)
float kursor_pocz_y = random(440 / skala, 880 / skala);       //

float cel_x = 2008.5000000390;                                //początkowa pozycja celu (m)
float cel_y = 1821.1333332716;                                //

final int mapa_szer = 700;                     //mapa rozmiar i położenie
final int mapa_wys  = 700;                     //
final int mapa_pocz_x = 10;                    //
final int mapa_pocz_y = 10;                    //

boolean pole_wiatru_w_trakcie_zaznaczania = false;     //czy pole wiatru jest teraz zaznaczane (0-nie lub 1-tak)

boolean pauza = false;                         //(false - cansat leci, true - pauza)

int wejscie_minuty_x = 0;  //5mpp              //minuty i częsci minut po przecinku cansata w osi x i y
int wejscie_minuty_y = 0;  //5mpp              //

float azymut_wiatru = 0;                       //azymut wiatru (0 - 360 stopni)
float sila_wiatru = 1;                         //siła

final float x_strzalki = -800;                       //zmienne służace do przesuwania symulatora
final float y_strzalki = -800;                       //

//tablica współrzędnych zapasowych punktów
//podane w metrach
float[] cele_zapasowe_y = {1389.0000000000 * skala, 1450.7333332716 * skala, 1975.4666667284 * skala, 1944.6000000000 * skala, 1697.6666667284 * skala};
float[] cele_zapasowe_x = {1442.9999999610 * skala, 1891.5000000390 * skala, 1325.9999999610 * skala, 1716.0000000390 * skala, 1618.4999999610 * skala};
float[] odleglosci_zapasowe = {0, 0, 0, 0, 0};

int restart = 0;                              //zmienne używane gdy restartuje się program
boolean nowa_symulacja = false;               //

short linka_P = 0;                            //więcej = bardziej pociągnięta linka (od 0 do 2)
short linka_L = 0;                            //p-prawa l-lewa

float rysowany_x = 0;                         //ile cansat przeleciał w x i y
float rysowany_y = 0;                         //

short aktualny_azymut = 0;                    //aktualny azymut cansata

int blisko_celu = 0;                          //wykrywanie jak blisko jest celu

float odleglosc_od_celu = 0;                  //odległość cansata od celu

int zapisano = 0;

String faza_algorytmu = "Calculating the wind";

int stronaZmiennych = 0;

boolean czyRysowacOdczytyWiatru = false;
boolean czyRysowacZielonaLinie = false;

float[] dane_azymut = {0};                    //tablica azymutów z każdym krokiem
float[] dane_przesuniecie = {0};              //tablica przesunięć w poszczególnych ruchach
float[] dane_wiatr_x = {0};                   //tu zapisywane są kolejne wartości x wiatru (wartość wiatru x w tym momencie:  dane_x[dane_x.length - 1]   )
float[] dane_wiatr_y = {0};                   //tu zapisywane są kolejne wartości y wiatru (wartość wiatru y w tym momencie:  dane_y[dane_y.length - 1]   )
float[] dane_wysokosc = {0};                  //
float[] azymut_wiatru_tablica = {0};          //tablica przechowująca azymuty wiatru 
float[] sila_wiatru_tablca = {0};             //tablica przechowująca siły wiatru
float[] x_teraz = {0};                        //kolejne x i y cansata
float[] y_teraz = {0};                        //

float[] x_wiatr_zielony = {0};                //tablice potrzebne potem do powtórek
float[] y_wiatr_zielony = {0};                //
float[] x_wiatr_fioletowy = {0};              //
float[] y_wiatr_fioletowy = {0};              //



////////////////////////////////////////////////////SETUP//////////////////////////////


void setup() {
    size(1366, 768, P2D);                                // wielkość okna aplikacji
    
    frameRate(FPS);
    
    fill(255);
    noStroke();
    

    x_wiatr.ustaw_chaotycznosc(nerwowosc_wiatru);        //ustawienia początkowe wiatru
    x_wiatr.ustaw_zakres(-90, 90);
    y_wiatr.ustaw_chaotycznosc(nerwowosc_wiatru);
    y_wiatr.ustaw_zakres(-90, 90);
    
    
    mini = createGraphics(width, height, P3D);
    mini.width  = 158;                                   //wielkość okna z zawartością 3d
    mini.height = 158;                                   //
    mini_x      = 843;                                   //położenie okna z zawartością 3d
    mini_y      = 610;                                   //
    
    trzyde = createGraphics(width, height, P3D);         
    trzyde.width  = 1000;                                //wielkość okna z zawartością 3d
    trzyde.height = 600;                                 //
    trzyde_x      = 0;                                   //położenie okna z zawartością 3d
    trzyde_y      = 0;                                   //
    
    
    puszka = loadShape("parachute_final_bend_x10.obj");
    
    przyciskDownload = loadImage("./przyciski/przycisk_zapisz.png");
    przyciskUpload =   loadImage("./przyciski/przycisk_otworz.png");
    przyciskPrawo =    loadImage("./przyciski/przycisk_prawo.png");
    przyciskLewo =     loadImage("./przyciski/przycisk_lewo.png");
    przyciskPauza =    loadImage("./przyciski/przycisk_pauza.png");
    przyciskPlay =     loadImage("./przyciski/przycisk_start.png");
    przyciskRestart =  loadImage("./przyciski/przycisk_restart.png");
    checkboxPrawda  =  loadImage("./przyciski/checkbox_prawda.png");
    checkboxFalsz   =  loadImage("./przyciski/checkbox_falsz.png");
    
    KMLSetup();
}

////////////////////////////////////////////////////DRAW//////////////////////////////

void draw() 
{
    if(Powtorka == true)
    {
        //podziałka która wybiera klatkę
        int klatka = dane_wysokosc.length - 1;
        
        wysokosc = dane_wysokosc[klatka];
    }
  
  
    setup3D();                                      //zaczyna 3D, 
                                                    //resetuje klatkę - ustawia tło na czarne
                                                    //obraca kamerą gdy przytrzymamy i przesuniemy myszkę
                                                    //robi matrycę
                                                    //przesuwa 3D na odpowiedni punkt 

    rysujMape();                                    //rysuje mape i czerwone linie na niej
                                                    //oraz rysuje podziałkę i granice mapy
    
    //if(Powtorka == false)
    okregiZasiegu();                                //oblicza gdzie może dolecieć CanSat i rysuje 2 okręgi:
                                                    //jeden fioletowy wskazuje gdzie może dolecieć CanSat
                                                    //drugi turkusowy wskazuje gdzie ma dolecieć CanSat
    if(Powtorka == false)
    nowyKrok();                                     //robi 1 nową klatkę do przodu
                                                    //oblicza gdzie będzie jego następny ruch
    
    
    rysujSciezke_2D(dokladnoscRysowaniaSciezki);    //rysuje ścieżkę 2D (żółtą)
    rysujSciezke_3D(dokladnoscRysowaniaSciezki);    //rysuje ścieżkę 3D (różową)
                                                    //ścieżki rysowane są z jakąś dokładnością, to znaczy że
                                                    //pomija się co kilka ruchów klatek, rzeby nie było za dużo obliczeń
    
    rysujLinieObliczjacaWiatr();                    //rysowanie zielonej lini, która ułatwia zobaczenie jak jest rysowany wiatr
    
    rysujCele();                                    //rysowanie celu głównego i celów zapasowych
    
    if(Powtorka == false)
    rysujFioletoweLinie();                          //rysowanie pomocniczych fioletowych lini, które ułatwiają zlokalizować cansata w 3D    
    
    
    rysujWersjeSymulatora();                        //rysowanie jaka jest wersja symulatora
    
    //if(Powtorka == true) - zmienne z JSONA
    rysujPoPrawej();                                //rysowanie z prawej strony różnych rzeczy:
                                                    //strony na zmienne, która pokazuje najważniejsze zmienne i te które nas interesują
                                                    //legendy, która tłumaczy czym są różne rzeczy
                                                    //przy restarcie robi jeszcze suwak
    
    //if(Powtorka == true) - wiatr z JSONA
    mapaWiatru();                                   //rysuje mapę wiatru, zaznaczenie gdzie może wiać wiatr, 
                                                    //zieloną linię, która pokazuje jak naprawdę wieje wiatr
                                                    //i różową linię, która pokazuje obliczony wiatr
    
    Minuty();                                       //oblicza minuty - stopnie geograficzne cansata
                                                    //minuty po przecinku - bez sekund
    
    if(Powtorka == false)
    algorytm_i_Tablice();                           //uruchamia algorytm, który steruje cansatem
                                                    //dodaje do tablic nowych zmiennych na ostatnie miejsce
                                                    //losuje wiatr
    
    zamkniecie3D();                                 //kończy rysowanie 3D
    
    //if(Powtorka == true) - dobry obrót z JSONA
    miniCansat();                                   //rysuje model cansata skierowany w tą samą stronę co zielona strzałka
    
    rysujPunktKamery();                             //rysuje żółtą kropkę na środku ekranu, żeby zorientować się gdzie jest środek kamery
}


void mouseDragged() 
{
    //suwak po prawej stronie, który wybiera wysokość z jaką zaczyna cansat
    if(mouseX > 1055 && mouseX < 1085 && mouseY > 40 && mouseY < 260)
    { 
        if(nowa_symulacja == true)
        {
            if(mouseY > 250)
            {
                wysokosc = 0;
            }
            else if (mouseY < 50)
            {
                wysokosc = 3000;
            }
            else
            {
                wysokosc = (200 - (mouseY - 50)) * 15;
            }
        }
    }
}



void mousePressed()           //jeżeli myszka przyciśnięta
{
    if(pauza == true)
    {
        if(mouseX > 1136 && mouseX < 1176 && mouseY > 352 && mouseY < 392 && zapisano == 0)
        {
            zapisPowtorki();   
        }
        else if(mouseX > 1194 && mouseX < 1234 && mouseY > 352 && mouseY < 392)
        {
            wybieraniePliku();
        }
    }

    
    
    if(mouseX > 1252  && mouseX < 1292 && mouseY > 352 && mouseY < 392)    //jeżeli jest tam gdzie przycisk pauzy
    {       
        pauza ^= true;                                                        //ustawia pauze na stan przeciwny
    }
    
    if(mouseX > 1020 && mouseX < 1060 && mouseY > 352 && mouseY < 392)     //przycisk po lewej      
    {       
        if(stronaZmiennych > 0) stronaZmiennych--;
        else stronaZmiennych = 4;
    }
    
    if(mouseX > 1078 && mouseX < 1118 && mouseY > 352 && mouseY < 392)     //przycisk po prawej   
    {       
        if(stronaZmiennych < 4) stronaZmiennych++;
        else stronaZmiennych = 0;
    }
    
    if(stronaZmiennych == 2)
    {
        if(mouseX > 1015 && mouseX < 1055 && mouseY > 15 && mouseY < 55)     //przycisk do rysowania wiatru
        {         
            czyRysowacOdczytyWiatru ^= true;
        }
        if(mouseX > 1015 && mouseX < 1055 && mouseY > 70 && mouseY < 110)     //przycisk do rysowania wiatru
        {         
            czyRysowacZielonaLinie ^= true;
        }
    }
    
    
    if(mouseX > 1310 && mouseX < 1350 && mouseY > 352 && mouseY < 392)  //przycisk restartu programu
    {
        zerowanieZmiennych();
    }



    if(kursor_jest_na_mapie_wiatru(mouseX, mouseY))                //jeżeli jest na mapie wiatru zaznacz nowy obszar wiatru
    { 
        //zaznaczanie pola wiatru
        if(pole_wiatru_w_trakcie_zaznaczania == false)
        {  
            x_wiatr.granica_zakresu1 = int(map(mouseX, 1010, 1366, -90, 90));
            y_wiatr.granica_zakresu1 = int(map(mouseY, 412, 768, -90, 90));
            pole_wiatru_w_trakcie_zaznaczania = true;
        }
        else
        {
            x_wiatr.ustaw_zakres(x_wiatr.granica_zakresu1, int(map(mouseX, 1010, 1366, -90, 90)));
            y_wiatr.ustaw_zakres(y_wiatr.granica_zakresu1, int(map(mouseY, 412, 768, -90, 90)));
            pole_wiatru_w_trakcie_zaznaczania = false;
        }
    } 
}
