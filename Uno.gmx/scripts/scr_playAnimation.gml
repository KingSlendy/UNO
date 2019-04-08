///scr_playAnimation(type, type_args...)
/*
    Type grab: (..., startX, startY, endX, endY, speed, action, spawn, target)
    Type answer: (..., x, y, image_index)
*/
switch (argument[0]) {
    case animation_grab:
        var anim = instance_create(argument[1], argument[2], obj_grabAnimation);
        anim.endX = argument[3];
        anim.endY = argument[4];
        anim.spd = argument[5];
        anim.action = argument[6];
        anim.spawn = argument[7];
        anim.target = argument[8];
        global.playingAnimation = true;
        break;
        
    case animation_answer:
        var anim = instance_create(argument[1], argument[2], obj_answerAnimation);
        anim.image_index = argument[3];
        break;
}
