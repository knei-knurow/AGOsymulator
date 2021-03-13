class wiatr
{
    float granica_zakresu1 = -1;
    float granica_zakresu2 = 1;
    float wiatr = 0;
    
    float nieskalowany_wiatr = 0;
    float zmiana = 0;
    float chaotycznosc = 50;
    
    void update(){update(chaotycznosc);}    //przeciążenie; odpowiednik tego, co w c++ byłoby update(int chaos = chaotycznosc)
    void update(float chaos)
    {
        chaos = sq(chaos / 100) / 2;                                                    //  
        float tmp = random(-1, 1);                                                      //  
        tmp *= abs(tmp);                                                                //  jako że 1*1=1, wartości graniczne nie zostaną przekroczone; zwiększa prawdopodobieństwo wystąpienia bliżej zera
        
        zmiana += tmp * chaos;                                                          //  tmp -> zmiana  
        if(tmp * zmiana > 0)                                                            //  czy mają ten sam znak
            zmiana -= tmp * pow(abs(zmiana), 1) * chaos;                                //  zabezpieczenie przed opuszczeniem zakresu
            
        nieskalowany_wiatr += zmiana * chaos;                                           //  zmiana -> nieskalowany wiatr
        if(zmiana * nieskalowany_wiatr > 0)                                             //  czy mają ten sam znak
            nieskalowany_wiatr -= zmiana * pow(abs(nieskalowany_wiatr), 0.3) * chaos;   //  zabezpieczenie przed opuszczeniem zakresu
            
        wiatr = map(nieskalowany_wiatr, -1, 1, granica_zakresu1, granica_zakresu2);     //  mapowanie do zakresu
    }
    
    void ustaw_zakres(float a, float b)
    {
        if(b>a)
        {
            granica_zakresu1 = b;
            granica_zakresu2 = a;
        }
        else
        {
            granica_zakresu1 = a;
            granica_zakresu2 = b;
        }
    }
    
    void ustaw_chaotycznosc(float a)
    {
        chaotycznosc = a;
    }
    
    void restart()
    {
        nieskalowany_wiatr = 0;
        wiatr = 0;
        zmiana = 0;
        granica_zakresu1 = -90;
        granica_zakresu2 = 90;
    }
}
