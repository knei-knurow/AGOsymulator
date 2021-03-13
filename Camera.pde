class eye
{
    float rot_x = 0;
    float rot_y = -90;
    
    float pos_x = 0;
    float pos_y = 0;
    float pos_z = 0;
    
    float dist = 700;
    
    void update()
    {
        
        trzyde.perspective(PI/3.0, float(trzyde.width)/float(trzyde.height), 10, 3000);        // fov, screen ratio, granica najbliższych rsowanaych rzeczy, granica najdalszych rysowanych rzeczy
        
        trzyde.camera(
          sin(radians(rot_x)) * cos(radians(rot_y)) * dist + pos_x,    sin(radians(rot_y)) * dist + pos_y,      cos(radians(rot_x)) * cos(radians(rot_y)) * dist + pos_z,   // eyeX, eyeY, eyeZ
          pos_x,                                                       pos_y,                                   pos_z,                                                      // centerX, centerY, centerZ
          0.0,                                                         1.0,                                     0.0);                                                       // upX, upY, upZ
        
        //trzyde.ortho(-1000,1000,-1000,1000,10,3000);
    }
    
    void orbitX(float angle)
    {
        rot_x += angle;
    }
    
    void orbitY(float angle)
    {
        rot_y += angle;   
        if (rot_y >= 90)          //zabezpieczenie przed oglądaniem do góry nogami
          rot_y = 89.5;
        else if (rot_y <= -90)
          rot_y = -89.5;
    }
    
    void zooom(float move)
    {
        dist += move;
    }
    
    void moveX(float move)
    {
        pos_x += move * cos(radians(rot_x));
        pos_z -= move * sin(radians(rot_x));
        
    }
    
    void moveY(float move)
    {
        pos_x -= move * sin(radians(rot_x)) * sin(radians(rot_y));
        pos_z -= move * cos(radians(rot_x)) * sin(radians(rot_y));
        pos_y += move * cos(radians(rot_y));
    }
    
    void moveZ(float move)
    {
        pos_x += move * sin(radians(rot_x)) * cos(radians(rot_y));
        pos_z += move * cos(radians(rot_x)) * cos(radians(rot_y));
        pos_y += move * sin(radians(rot_y));
    }
}

class eye2
{
    float rot_x = camera.rot_x;
    float rot_y = camera.rot_y;
    
    float dist = 50;
    
    void update()
    {
        mini.perspective(PI/3.0, float(mini.width)/float(mini.height), 10, 3000);        // fov, screen ratio, granica najbliższych rsowanaych rzeczy, granica najdalszych rysowanych rzeczy
        
        mini.camera(
          sin(radians(rot_x)) * cos(radians(rot_y)) * dist,    sin(radians(rot_y)) * dist,      cos(radians(rot_x)) * cos(radians(rot_y)) * dist,    // eyeX, eyeY, eyeZ
          0,                                                   -9,                               0,                                                  // centerX, centerY, centerZ
          0.0,                                                 1.0,                             0.0);                                                // upX, upY, upZ
          
          rot_x = camera.rot_x;
          rot_y = camera.rot_y;
    }

}

class movement
{
    boolean lastPressed = false;
    
    float lastX;
    float lastY;
    
    float movementX = 0;
    float movementY = 0;
    
    boolean legalMove = false;
    
    boolean xfit(float x)
    {
        return(trzyde_x <= x && x <= trzyde_x + trzyde.width);
    }
    
    boolean yfit(float y)
    {
        return(trzyde_y <= y && y <= trzyde_y + trzyde.height);
    }
    
    
    
    void update()
    {
        if(mousePressed)
        {
            if(lastPressed)
            {
                if(legalMove)
                {
                    movementX = mouseX - lastX;
                    movementY = mouseY - lastY;
                }
                else
                {
                    movementX = 0;
                    movementY = 0;
                    
                }
            }
            else
            {
                if(xfit(mouseX)&&yfit(mouseY))
                legalMove = true;
                else
                legalMove = false;
                
            }
            lastX = mouseX;
            lastY = mouseY;
            lastPressed = true;
        }
        else
        {
            movementX /= 1.2;
            movementY /= 1.2;
            lastPressed = false;
        }
        
        if((keyCode != SHIFT) || !keyPressed)
        {
            camera.orbitX(mouse.movementX * -150 / trzyde.width);
            camera.orbitY(mouse.movementY * -90 / trzyde.height);
        }
        else
        {
           camera.moveX(mouse.movementX * -1200 / trzyde.width);
           camera.moveY(mouse.movementY * -750 / trzyde.height);
        }
    }
}



void mouseWheel(MouseEvent event)
{
    if((keyCode != SHIFT) || !keyPressed)
        camera.zooom(event.getCount() * 10);
    else
        camera.moveZ(event.getCount() * 10);
}
