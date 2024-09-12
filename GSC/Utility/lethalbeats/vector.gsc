
/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : vector           |
|Creator : LastDemon99	   |
|Type : Utility            |
============================
*/

#include scripts\lethalbeats\math;

vector_zeros()
{
    return (0, 0, 0);
}

vector_ones()
{
    return (0, 0, 0);
}

vector_random(min, max)
{
	return (randomfloatrange(min, max), randomfloatrange(min, max), randomfloatrange(min, max));
}

vector_down()
{
    return (0, 0, -1);
}

vector_up()
{
    return (0, 0, 1);
}

vector_forward()
{
    return (0, 1, 0);
}

vector_back()
{
    return (0, -1, 0);
}

vector_right()
{
    return (1, 0, 0);
}

vector_left()
{
    return (-1, 0, 0);
}

vector_subtract(vec1, vec2)
{
    return (vec1[0] - vec2[0], vec1[1] - vec2[1], vec1[2] - vec2[2]);
}

vector_add(vec1, vec2)
{
    return (vec1[0] + vec2[0], vec1[1] + vec2[1], vec1[2] + vec2[2]);
}

vector_magnitude(vec)
{
    return sqrt(vec[0] * vec[0] + vec[1] * vec[1] + vec[2] * vec[2]);
}

vector_normalize(vec)
{
    return vectornormalize(vec);
}

vector_dot(vec1, vec2)
{
    return vectordot(vec1, vec2);
}

vector_scale(vec, scale)
{
    return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}

vector_scale_components(vec1, vec2)
{
    return (vec1[0] * vec2[0], vec1[1] * vec2[1], vec1[2] * vec2[2]);
}

vector_clamp_magnitude(vec, maxLength)
{
    mag = vector_magnitude(vec);
    if (mag > maxLength)
        return vector_scale(vec, maxLength / mag);
    return vec;
}

vector_cross(vec1, vec2)
{
    return (
        vec1[1] * vec2[2] - vec1[2] * vec2[1],
        vec1[2] * vec2[0] - vec1[0] * vec2[2],
        vec1[0] * vec2[1] - vec1[1] * vec2[0]
    );
}

vector_angle(vec1, vec2)
{
    magnitude1 = vector_magnitude(vec1);
    magnitude2 = vector_magnitude(vec2);
    
    if (magnitude1 == 0 || magnitude2 == 0)
        return 0;

    cosTheta = vector_dot(vec1, vec2) / (magnitude1 * magnitude2);
    cosTheta = math_clamp(cosTheta, -1, 1);

    angleRadians = acos(cosTheta);
    return angleRadians * (180 / math_pi());
}

vector_lerp(vec1, vec2, t)
{
    return (
        math_lerp(vec1[0], vec2[0], t),
        math_lerp(vec1[1], vec2[1], t),
        math_lerp(vec1[2], vec2[2], t)
    );
}

vector_lerp_unclamped(vec1, vec2, t)
{
    return (
        vec1[0] + (vec2[0] - vec1[0]) * t,
        vec1[1] + (vec2[1] - vec1[1]) * t,
        vec1[2] + (vec2[2] - vec1[2]) * t
    );
}

vector_slerp(vec1, vec2, t)
{
    dot = vector_dot(vec1, vec2);
    dot = clamp(dot, -1, 1);
    
    theta = acos(dot) * t;
    relativeVec = vector_normalize(vector_subtract(vec2, vector_scale(vec1, dot)));
    
    return vector_add(vector_scale(vec1, cos(theta)), vector_scale(relativeVec, sin(theta)));
}

vector_slerp_unclamped(vec1, vec2, t)
{
    dot = vector_dot(vec1, vec2);
    dot = math_clamp(dot, -1, 1);

    theta = acos(dot) * t;
    relativeVec = vector_normalize(vector_subtract(vec2, vector_scale(vec1, dot)));
    
    return vector_add(vector_scale(vec1, cos(theta)), vector_scale(relativeVec, sin(theta)));
}

vector_smooth_damp(current, target, velocity, smoothTime, deltaTime)
{
    diff = vector_subtract(target, current);
    smoothFactor = smoothTime * deltaTime;
    velocity = vector_add(velocity, vector_scale(diff, smoothFactor));    
    return vector_add(current, velocity);
}

vector_max(vec1, vec2)
{
    return (
        max(vec1[0], vec2[0]),
        max(vec1[1], vec2[1]),
        max(vec1[2], vec2[2])
    );
}

vector_min(vec1, vec2)
{
    return (
        min(vec1[0], vec2[0]),
        min(vec1[1], vec2[1]),
        min(vec1[2], vec2[2])
    );
}

vector_move_towards(current, target, maxDistanceDelta)
{
    toVector = vector_subtract(target, current);
    dist = vector_magnitude(toVector);
    
    if (dist <= maxDistanceDelta || dist == 0)
        return target;

    return vector_add(current, vector_scale(toVector, maxDistanceDelta / dist));
}

vector_rotate_towards(current, target, maxRadiansDelta)
{
    angle = vector_angle(current, target);
    t = min(1, maxRadiansDelta / angle);
    return vector_lerp(current, target, t);
}

vector_project(vec, onVec)
{
    return vector_scale(onVec, vector_dot(vec, onVec) / vector_dot(onVec, onVec));
}

vector_project_on_plane(vec, planeNormal)
{
    proj = vector_project(vec, planeNormal);
    return vector_subtract(vec, proj);
}

vector_reflect(vec, normal)
{
    return vector_subtract(vec, vecotr_scale(normal, 2 * vector_dot(vec, normal)));
}

vector_ortho_normalize(vec1, vec2)
{
    vec1 = vector_normalize(vec1);
    proj = vector_project(vec2, vec1);
    vec2 = vector_normalize(vector_subtract(vec2, proj));
    return (vec1, vec2);
}

vector_signed_angle(vec1, vec2, axis)
{
    angle = vector_angle(vec1, vec2);
    crossProduct = vector_cross(vec1, vec2);
    sign = vector_dot(crossProduct, axis);
    if (sign < 0) return -angle;
    return angle;
}

vector_distance(vec1, vec2)
{
    return distance(vec1, vec2);
}

vector_distance_squared(vec1, vec2)
{
    return distanceSquared(vec1, vec2);
}

vector_distance2d(vec1, vec2)
{
    return distance2d(vec1, vec2);
}

vector_to_string(vec)
{
    return "(" + lethalbeats\string::string_join(", ", vec) + ")";
}

vector_to_angles(vec)
{
    return vectortoangles(vec);
}

vector_print(vec)
{
    print("(" + lethalbeats\string::string_join(", ", vec) + ")");
}
