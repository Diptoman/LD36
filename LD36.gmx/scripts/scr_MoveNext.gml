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
    canMove = false;
    decisionMade = true;
}


/*
Check for existing collision of particles in the same grid
*/
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
            alarm[2] = 1; //Destroy this
        }
    }
}

/*
Check for direction changer
*/
if ((!decisionMade) && (canMove))
{
    directionChanger = collision_point(x,y,obj_directionalPath,0,1);
    if (directionChanger)
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
    }
}

/*
Move to next grid based on final currentDirection
*/
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
