var xDirectionSign = argument0; //+1, 0 or -1
var yDirectionSign = argument1; //+1, 0 or -1
var decisionMade = false;
canMove = true;

//Check for existing collision of particles in the same grid
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
    }
    
}

//Check for 

//Check for path. Can only move if there is a path
if (collision_point(x+xDirectionSign*32,y+yDirectionSign*32,obj_path,0,0) && (!decisionMade))
{
    canMove = true;
}

//Decide next movement if previous conditions not met
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
        }
    }
}

//Move to next grid based on final currentDirection
if (canMove)
{
    if (currentDirection == "l")
        TweenFire(id,x__,EaseLinear,0,0,0,global.alarmTiming,x,x-32);
    else if (currentDirection == "r")
        TweenFire(id,x__,EaseLinear,0,0,0,global.alarmTiming,x,x+32);
    else if (currentDirection == "u")
        TweenFire(id,y__,EaseLinear,0,0,0,global.alarmTiming,y,y-32);
    else if (currentDirection == "d")
        TweenFire(id,y__,EaseLinear,0,0,0,global.alarmTiming,y,y+32);
        
}
