var xDirectionSign = argument0; //+1, 0 or -1
var yDirectionSign = argument1; //+1, 0 or -1
var decisionMade = false;
canMove = true;

/*
Check for end point
*/
endPoint = collision_point(x,y,obj_end,0,1);
if (endPoint)
{
    if (endPoint.type == type)
    {
        canMove = false;
        decisionMade = true;
        if (!endPoint.isFinished)
        {
            endPoint.isFinished = true;
            obj_controller.endPointReaches += 1;
        }
    }
    else
    {
        if (currentDirection == "r")
        {
            currentDirection = "l";
        }
        else if (currentDirection == "l")
        {
            currentDirection = "r";
        }
        else if (currentDirection == "u")
        {
            currentDirection = "d";
        }
        else if (currentDirection == "d")
        {
            currentDirection = "u";
        }
        
        if (currentDirection == "r")
        {
            xDirectionSign = 1;
            yDirectionSign = 0;
        }
        else if (currentDirection == "l")
        {
            xDirectionSign = -1;
            yDirectionSign = 0;
        }
        else if (currentDirection == "u")
        {
            xDirectionSign = 0;
            yDirectionSign = -1;
        }
        else if (currentDirection == "d")
        {
            xDirectionSign = 0;
            yDirectionSign = 1;
        }
    }
}

/*
Check for portals
*/
if ((!decisionMade) && (canMove))
{
    portal = collision_point(x,y,obj_portal,0,1);
    if (portal)
    {
        //If no destination
        if (portal.destinationID == -1)
        {
            instance_destroy();
            canMove = false;
            decisionMade = true;
        }
        else
        {
            //Teleport!
            x = (portal.destinationID).x;
            y = (portal.destinationID).y;
            checkForCollisions = false;
            alarm[9] = 1;
        }
    }
}

/*
Check for color shifter
*/
if ((!decisionMade) && (canMove))
{
    colorShifter = collision_point(x,y,obj_colorShifter,0,1);
    if (colorShifter)
    {
        if (type == "+")
            type = "-";
        else
            type = "+";
    }
}

/*
Check for existing collision of particles in the same grid
*/
if ((!decisionMade) && (canMove) && (checkForCollisions))
{
    otherParticle = collision_point(x,y,obj_particle,0,1);
    if (otherParticle)
    {
        //If same sign
        if (otherParticle.type == type)
        {
            //Move in reverse
            if (xDirectionSign != 0) //If left or right
            {
                //Change currentDirection
                if (currentDirection == "l") currentDirection = "r";
                else if (currentDirection == "r") currentDirection = "l";
            }
            else //If up or down
            {
                //Change currentDirection
                if (currentDirection == "d") currentDirection = "u";
                else if (currentDirection == "u") currentDirection = "d";
            }
        }
        else //If opposite sign
        {
            instance_create(x,y,obj_neutralParticle);
            alarm[2] = 1; //Destroy this
            canMove = false;
        }
    
    }
}


/*
Check for path in the next grid. Can only move if there is a path
*/
if (collision_point(x+xDirectionSign*32,y+yDirectionSign*32,obj_path,0,0) && (!decisionMade))
{
    canMove = true;
}

/*
Check for direction changer
*/
if ((!decisionMade) && (canMove))
{
    directionChanger = collision_point(x,y,obj_directionalPath,0,1);
    if (directionChanger) && (!collision_point(x+xDirectionSign*32,y+yDirectionSign*32,obj_particle,0,1))
    {
        var changeDirection;
        changeDirection = false;
        
        if (currentDirection == "l") //Left
        {
            if ((directionChanger.direction1 == "r") || (directionChanger.direction2 == "r"))
            {
                changeDirection = true;
                //Change currentDirection
                if (directionChanger.direction1 == "r") currentDirection = directionChanger.direction2;
                else currentDirection = directionChanger.direction1; 
            }
        } 
        else if (currentDirection == "r") //Right
        {
            if ((directionChanger.direction1 == "l") || (directionChanger.direction2 == "l"))
            {
                changeDirection = true;
                //Change currentDirection
                if (directionChanger.direction1 == "l") currentDirection = directionChanger.direction2;
                else currentDirection = directionChanger.direction1;
            }
        }
        else if (currentDirection == "u") //Up
        {
            if ((directionChanger.direction1 == "d") || (directionChanger.direction2 == "d"))
            {
                changeDirection = true;
                //Change currentDirection
                if (directionChanger.direction1 == "d") currentDirection = directionChanger.direction2;
                else currentDirection = directionChanger.direction1;
            }
        }
        else if (currentDirection == "d") //Down
        {
            if ((directionChanger.direction1 == "u") || (directionChanger.direction2 == "u"))
            {
                changeDirection = true;
                //Change currentDirection
                if (directionChanger.direction1 == "u") currentDirection = directionChanger.direction2;
                else currentDirection = directionChanger.direction1;
            }
        }
        
        if (currentDirection == "r")
        {
            xDirectionSign = 1;
            yDirectionSign = 0;
        }
        else if (currentDirection == "l")
        {
            xDirectionSign = -1;
            yDirectionSign = 0;
        }
        else if (currentDirection == "u")
        {
            xDirectionSign = 0;
            yDirectionSign = -1;
        }
        else if (currentDirection == "d")
        {
            xDirectionSign = 0;
            yDirectionSign = 1;
        }
    }
}

/*
Check for collisions with other particles in the next grid
*/
if ((!decisionMade) && (canMove))
{
    //No collision with other particle
    otherParticle = collision_point(x+xDirectionSign*32,y+yDirectionSign*32,obj_particle,0,1);
    if (otherParticle)
    {
        //If same sign
        if (otherParticle.type == type)
        {
            //Move in reverse
            if (xDirectionSign != 0) //If left or right
            {
                //Change currentDirection
                if (currentDirection == "l") currentDirection = "r";
                else if (currentDirection == "r") currentDirection = "l";
            }
            else //If up or down
            {
                //Change currentDirection
                if (currentDirection == "d") currentDirection = "u";
                else if (currentDirection == "u") currentDirection = "d";
            }
        }
        else //If opposite sign
        {
            instance_create(x,y,obj_neutralParticle);
            canMove = false;
            alarm[2] = 1; //Destroy this
        }
    }
}

/*
Check for neutral particle collision
*/
if ((!decisionMade) && (canMove))
{
    //No collision with other particle
    neutralParticle = collision_point(x+xDirectionSign*32,y+yDirectionSign*32,obj_neutralParticle,0,1);
    if (neutralParticle)
    {
        //Move in reverse
        if (xDirectionSign != 0) //If left or right
        {
            //Change currentDirection
            if (currentDirection == "l") currentDirection = "r";
            else if (currentDirection == "r") currentDirection = "l";
        }
        else //If up or down
        {
            //Change currentDirection
            if (currentDirection == "d") currentDirection = "u";
            else if (currentDirection == "u") currentDirection = "d";
        }
        
        
    //Check if on directional changer
    directionChanger = collision_point(x,y,obj_directionalPath,0,1);
    if (directionChanger) && (!collision_point(x+xDirectionSign*32,y+yDirectionSign*32,obj_particle,0,1))
    {
        var changeDirection;
        changeDirection = false;
        
        if (currentDirection == "l") //Left
        {
            if ((directionChanger.direction1 == "r") || (directionChanger.direction2 == "r"))
            {
                changeDirection = true;
                //Change currentDirection
                if (directionChanger.direction1 == "r") currentDirection = directionChanger.direction2;
                else currentDirection = directionChanger.direction1; 
            }
        } 
        else if (currentDirection == "r") //Right
        {
            if ((directionChanger.direction1 == "l") || (directionChanger.direction2 == "l"))
            {
                changeDirection = true;
                //Change currentDirection
                if (directionChanger.direction1 == "l") currentDirection = directionChanger.direction2;
                else currentDirection = directionChanger.direction1;
            }
        }
        else if (currentDirection == "u") //Up
        {
            if ((directionChanger.direction1 == "d") || (directionChanger.direction2 == "d"))
            {
                changeDirection = true;
                //Change currentDirection
                if (directionChanger.direction1 == "d") currentDirection = directionChanger.direction2;
                else currentDirection = directionChanger.direction1;
            }
        }
        else if (currentDirection == "d") //Down
        {
            if ((directionChanger.direction1 == "u") || (directionChanger.direction2 == "u"))
            {
                changeDirection = true;
                //Change currentDirection
                if (directionChanger.direction1 == "u") currentDirection = directionChanger.direction2;
                else currentDirection = directionChanger.direction1;
            }
        }
        
        if (currentDirection == "r")
        {
            xDirectionSign = 1;
            yDirectionSign = 0;
        }
        else if (currentDirection == "l")
        {
            xDirectionSign = -1;
            yDirectionSign = 0;
        }
        else if (currentDirection == "u")
        {
            xDirectionSign = 0;
            yDirectionSign = -1;
        }
        else if (currentDirection == "d")
        {
            xDirectionSign = 0;
            yDirectionSign = 1;
        }
    }
        
    }
}

/*
Check for splitters, after collision checking done
*/
if ((!decisionMade) && (canMove))
{
    splitter = collision_point(x,y,obj_directionalSplitter,0,1);
    if (splitter)
    {
        //Left split
        if ((splitter.direction1 == "l") || (splitter.direction2 == "l")) 
        {
            particleObj = instance_create(x,y,obj_particle);
            particleObj.type = type;
            particleObj.currentDirection = "l";
            particleObj.alarm[1] = 1;
            particleObj.alarm[4] = 1;
            particleObj.isOriginal = false;
            particleObj.checkForCollisions = false;
            particleObj.alarm[9] = 2;
        }
        //Right split
        if ((splitter.direction1 == "r") || (splitter.direction2 == "r")) 
        {
            particleObj = instance_create(x,y,obj_particle);
            particleObj.type = type;
            particleObj.currentDirection = "r";
            particleObj.alarm[1] = 1;
            particleObj.alarm[4] = 1;
            particleObj.isOriginal = false;
            particleObj.checkForCollisions = false;
            particleObj.alarm[9] = 2;
        }
        //Up split
        if ((splitter.direction1 == "u") || (splitter.direction2 == "u")) 
        {
            particleObj = instance_create(x,y,obj_particle);
            particleObj.type = type;
            particleObj.currentDirection = "u";
            particleObj.alarm[1] = 1;
            particleObj.alarm[4] = 1;
            particleObj.isOriginal = false;
            particleObj.checkForCollisions = false;
            particleObj.alarm[9] = 2;
        }
        //Down split
        if ((splitter.direction1 == "d") || (splitter.direction2 == "d")) 
        {
            particleObj = instance_create(x,y,obj_particle);
            particleObj.type = type;
            particleObj.currentDirection = "d";
            particleObj.alarm[1] = 1;
            particleObj.alarm[4] = 1;
            particleObj.isOriginal = false;
            particleObj.checkForCollisions = false;
            particleObj.alarm[9] = 2;
        }
        //Stop other actions and delete this
        decisionMade = true;
        alarm[2] = 1;
        
        //Create path if not already there
        if (!collision_point(splitter.x,splitter.y,obj_path,0,0))
            instance_create(splitter.x,splitter.y,obj_path);
        
        //Move the splitter out of view to be taken back later
        splitter.placeX = splitter.x;
        splitter.placeY = splitter.y;
        splitter.x = -32;
        splitter.y = -32;
    }
}

//Bounce if next grid is not a tile
if (collision_point(x+xDirectionSign*32,y+yDirectionSign*32,obj_path,0,1) 
    || collision_point(x+xDirectionSign*32,y+yDirectionSign*32,obj_directionalPath,0,1) 
    || collision_point(x+xDirectionSign*32,y+yDirectionSign*32,obj_directionalSplitter,0,1)
    || collision_point(x+xDirectionSign*32,y+yDirectionSign*32,obj_portal,0,1)
    || collision_point(x+xDirectionSign*32,y+yDirectionSign*32,obj_end,0,1)
    || collision_point(x+xDirectionSign*32,y+yDirectionSign*32,obj_colorShifter,0,1)
    || collision_point(x,y,obj_end,0,1)
    || (!canMove))
{
    
}
else
{
    if (currentDirection == "u")
        currentDirection = "d";
    else if (currentDirection == "d")
        currentDirection = "u";
    else if (currentDirection == "l")
        currentDirection = "r";
    else if (currentDirection == "r")
        currentDirection = "l";
        
    //Check if on directional changer
    directionChanger = collision_point(x,y,obj_directionalPath,0,1);
    if (directionChanger) && (!collision_point(x+xDirectionSign*32,y+yDirectionSign*32,obj_particle,0,1))
    {
        var changeDirection;
        changeDirection = false;
        
        if (currentDirection == "l") //Left
        {
            if ((directionChanger.direction1 == "r") || (directionChanger.direction2 == "r"))
            {
                changeDirection = true;
                //Change currentDirection
                if (directionChanger.direction1 == "r") currentDirection = directionChanger.direction2;
                else currentDirection = directionChanger.direction1; 
            }
        } 
        else if (currentDirection == "r") //Right
        {
            if ((directionChanger.direction1 == "l") || (directionChanger.direction2 == "l"))
            {
                changeDirection = true;
                //Change currentDirection
                if (directionChanger.direction1 == "l") currentDirection = directionChanger.direction2;
                else currentDirection = directionChanger.direction1;
            }
        }
        else if (currentDirection == "u") //Up
        {
            if ((directionChanger.direction1 == "d") || (directionChanger.direction2 == "d"))
            {
                changeDirection = true;
                //Change currentDirection
                if (directionChanger.direction1 == "d") currentDirection = directionChanger.direction2;
                else currentDirection = directionChanger.direction1;
            }
        }
        else if (currentDirection == "d") //Down
        {
            if ((directionChanger.direction1 == "u") || (directionChanger.direction2 == "u"))
            {
                changeDirection = true;
                //Change currentDirection
                if (directionChanger.direction1 == "u") currentDirection = directionChanger.direction2;
                else currentDirection = directionChanger.direction1;
            }
        }
        
        if (currentDirection == "r")
        {
            xDirectionSign = 1;
            yDirectionSign = 0;
        }
        else if (currentDirection == "l")
        {
            xDirectionSign = -1;
            yDirectionSign = 0;
        }
        else if (currentDirection == "u")
        {
            xDirectionSign = 0;
            yDirectionSign = -1;
        }
        else if (currentDirection == "d")
        {
            xDirectionSign = 0;
            yDirectionSign = 1;
        }
    }
    
    //instance_destroy();
}

/*
Move to next grid based on final currentDirection
*/
if (canMove)
{
    if (currentDirection == "l")
    {
        xDirectionSign = -1;
        yDirectionSign = 0;
        TweenFire(id,x__,EaseLinear,0,0,0,global.alarmTiming-1,x,x-32);
    }
    else if (currentDirection == "r")
    {
        xDirectionSign = 1;
        yDirectionSign = 0;
        TweenFire(id,x__,EaseLinear,0,0,0,global.alarmTiming-1,x,x+32);
    }
    else if (currentDirection == "u")
    {
        xDirectionSign = 0;
        yDirectionSign = -1;
        TweenFire(id,y__,EaseLinear,0,0,0,global.alarmTiming-1,y,y-32);
    }
    else if (currentDirection == "d")
    {
        xDirectionSign = 0;
        yDirectionSign = 1;
        TweenFire(id,y__,EaseLinear,0,0,0,global.alarmTiming-1,y,y+32);
    }
        
}
