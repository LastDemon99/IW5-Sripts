#include lethalbeats\vector;

angles_orient_to_normal(normal, yaw)
{
    forward = anglesToForward((0, yaw, 0));
    right = vector_cross(forward, normal);
    right = vectorNormalize(right);
    forward = vector_cross(normal, right);
    forward = vectorNormalize(forward);
    return vector_to_euler_angles(forward, normal);
}

angles_look_at(start, end)
{
    dir = vectorNormalize(vector_subtract(end, start));
    return vectorToAngles(dir);
}
