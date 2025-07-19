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

#include lethalbeats\math;

vector_truncate(vec, places)
{
    return (math_truncate(vec[0], places), math_truncate(vec[1], places), math_truncate(vec[2], places));
}

/*
///DocStringBegin
detail: vector_zeros(): <Vector>
summary: Returns a vector with all components set to zero.
///DocStringEnd
*/
vector_zeros()
{
    return (0, 0, 0);
}

/*
///DocStringBegin
detail: vector_ones(): <Vector>
summary: Returns a vector with all components set to one.
///DocStringEnd
*/
vector_ones()
{
    return (1, 1, 1);
}

/*
///DocStringBegin
detail: vector_random(min: <Float>, max?: <Float>): <Vector>
summary: Returns a vector with random components. If max is defined, components are in the range [min, max], otherwise in the range [-min/2, min/2].
///DocStringEnd
*/
vector_random(min, max)
{
    if (isDefined(max)) return (randomfloatrange(min, max), randomfloatrange(min, max), randomfloatrange(min, max));
    else return (randomfloat(min) - min * 0.5, randomfloat(min) - min * 0.5, randomfloat(min) - min * 0.5);
}

/*
///DocStringBegin
detail: vector_random_range(num_min: <Float>, num_max: <Float>): <Vector>
summary: Returns a vector with random components in the range [-num_max, num_max].
///DocStringEnd
*/
vector_random_range(num_min, num_max)
{
    x = randomfloatrange(num_min, num_max);
    if (randomint(2) == 0) x *= -1;

    y = randomfloatrange(num_min, num_max);
    if (randomint(2) == 0) y *= -1;

    z = randomfloatrange(num_min, num_max);
    if (randomint(2) == 0) z *= -1;

    return (x, y, z);
}

/*
///DocStringBegin
detail: vector_down(): <Vector>
summary: Returns a vector pointing downwards.
///DocStringEnd
*/
vector_down()
{
    return (0, 0, -1);
}

/*
///DocStringBegin
detail: vector_up(): <Vector>
summary: Returns a vector pointing upwards.
///DocStringEnd
*/
vector_up()
{
    return (0, 0, 1);
}

/*
///DocStringBegin
detail: vector_forward(): <Vector>
summary: Returns a vector pointing forward.
///DocStringEnd
*/
vector_forward()
{
    return (0, 1, 0);
}

/*
///DocStringBegin
detail: vector_back(): <Vector>
summary: Returns a vector pointing backward.
///DocStringEnd
*/
vector_back()
{
    return (0, -1, 0);
}

/*
///DocStringBegin
detail: vector_right(): <Vector>
summary: Returns a vector pointing to the right.
///DocStringEnd
*/
vector_right()
{
    return (1, 0, 0);
}

/*
///DocStringBegin
detail: vector_left(): <Vector>
summary: Returns a vector pointing to the left.
///DocStringEnd
*/
vector_left()
{
    return (-1, 0, 0);
}

/*
///DocStringBegin
detail: vector_subtract(vec1: <Vector>, vec2: <Vector>): <Vector>
summary: Returns the result of subtracting vec2 from vec1.
///DocStringEnd
*/
vector_subtract(vec1, vec2)
{
    return (vec1[0] - vec2[0], vec1[1] - vec2[1], vec1[2] - vec2[2]);
}

/*
///DocStringBegin
detail: vector_add(vec1: <Vector>, vec2: <Vector>): <Vector>
summary: Returns the result of adding vec1 and vec2.
///DocStringEnd
*/
vector_add(vec1, vec2)
{
    return (vec1[0] + vec2[0], vec1[1] + vec2[1], vec1[2] + vec2[2]);
}

/*
///DocStringBegin
detail: vector_magnitude(vec: <Vector>): <Float>
summary: Returns the magnitude (length) of the vector.
///DocStringEnd
*/
vector_magnitude(vec)
{
    return sqrt(vec[0] * vec[0] + vec[1] * vec[1] + vec[2] * vec[2]);
}

/*
///DocStringBegin
detail: vector_normalize(vec: <Vector>): <Vector>
summary: Returns the normalized (unit) vector of the given vector.
///DocStringEnd
*/
vector_normalize(vec)
{
    return vectornormalize(vec);
}

/*
///DocStringBegin
detail: vector_dot(vec1: <Vector>, vec2: <Vector>): <Float>
summary: Returns the dot product of vec1 and vec2.
///DocStringEnd
*/
vector_dot(vec1, vec2)
{
    return vectordot(vec1, vec2);
}

/*
///DocStringBegin
detail: vector_scale(vec: <Vector>, scale: <Float>): <Vector>
summary: Returns the result of scaling the vector by the given scale.
///DocStringEnd
*/
vector_scale(vec, scale)
{
    return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}

/*
///DocStringBegin
detail: vector_scale_components(vec1: <Vector>, vec2: <Vector>): <Vector>
summary: Returns the result of component-wise scaling of vec1 by vec2.
///DocStringEnd
*/
vector_scale_components(vec1, vec2)
{
    return (vec1[0] * vec2[0], vec1[1] * vec2[1], vec1[2] * vec2[2]);
}

/*
///DocStringBegin
detail: vector_clamp_magnitude(vec: <Vector>, maxLength: <Float>): <Vector>
summary: Returns the vector with its magnitude clamped to maxLength.
///DocStringEnd
*/
vector_clamp_magnitude(vec, maxLength)
{
    mag = vector_magnitude(vec);
    if (mag > maxLength)
        return vector_scale(vec, maxLength / mag);
    return vec;
}

/*
///DocStringBegin
detail: vector_cross(vec1: <Vector>, vec2: <Vector>): <Vector>
summary: Returns the cross product of vec1 and vec2.
///DocStringEnd
*/
vector_cross(vec1, vec2)
{
    return (
        vec1[1] * vec2[2] - vec1[2] * vec2[1],
        vec1[2] * vec2[0] - vec1[0] * vec2[2],
        vec1[0] * vec2[1] - vec1[1] * vec2[0]
    );
}

/*
///DocStringBegin
detail: vector_angle(vec1: <Vector>, vec2: <Vector>): <Float>
summary: Returns the angle in degrees between vec1 and vec2.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: vector_lerp(vec1: <Vector>, vec2: <Vector>, t: <Float>): <Vector>
summary: Returns the linear interpolation between vec1 and vec2 by t.
///DocStringEnd
*/
vector_lerp(vec1, vec2, t)
{
    return (
        math_lerp(vec1[0], vec2[0], t),
        math_lerp(vec1[1], vec2[1], t),
        math_lerp(vec1[2], vec2[2], t)
    );
}

/*
///DocStringBegin
detail: vector_lerp_unclamped(vec1: <Vector>, vec2: <Vector>, t: <Float>): <Vector>
summary: Returns the linear interpolation between vec1 and vec2 by t without clamping.
///DocStringEnd
*/
vector_lerp_unclamped(vec1, vec2, t)
{
    return (
        vec1[0] + (vec2[0] - vec1[0]) * t,
        vec1[1] + (vec2[1] - vec1[1]) * t,
        vec1[2] + (vec2[2] - vec1[2]) * t
    );
}

/*
///DocStringBegin
detail: vector_slerp(vec1: <Vector>, vec2: <Vector>, t: <Float>): <Vector>
summary: Returns the spherical linear interpolation between vec1 and vec2 by t.
///DocStringEnd
*/
vector_slerp(vec1, vec2, t)
{
    dot = vector_dot(vec1, vec2);
    dot = math_clamp(dot, -1, 1);
    
    theta = acos(dot) * t;
    relativeVec = vector_normalize(vector_subtract(vec2, vector_scale(vec1, dot)));
    
    return vector_add(vector_scale(vec1, cos(theta)), vector_scale(relativeVec, sin(theta)));
}

/*
///DocStringBegin
detail: vector_slerp_unclamped(vec1: <Vector>, vec2: <Vector>, t: <Float>): <Vector>
summary: Returns the spherical linear interpolation between vec1 and vec2 by t without clamping.
///DocStringEnd
*/
vector_slerp_unclamped(vec1, vec2, t)
{
    dot = vector_dot(vec1, vec2);
    dot = math_clamp(dot, -1, 1);

    theta = acos(dot) * t;
    relativeVec = vector_normalize(vector_subtract(vec2, vector_scale(vec1, dot)));
    
    return vector_add(vector_scale(vec1, cos(theta)), vector_scale(relativeVec, sin(theta)));
}

/*
///DocStringBegin
detail: vector_smooth_damp(current: <Vector>, target: <Vector>, velocity: <Vector>, smoothTime: <Float>, deltaTime: <Float>): <Vector>
summary: Smoothly dampens the vector from current to target using the given velocity, smoothTime, and deltaTime.
///DocStringEnd
*/
vector_smooth_damp(current, target, velocity, smoothTime, deltaTime)
{
    diff = vector_subtract(target, current);
    smoothFactor = smoothTime * deltaTime;
    velocity = vector_add(velocity, vector_scale(diff, smoothFactor));    
    return vector_add(current, velocity);
}

/*
///DocStringBegin
detail: vector_max(vec1: <Vector>, vec2: <Vector>): <Vector>
summary: Returns a vector with the maximum components of vec1 and vec2.
///DocStringEnd
*/
vector_max(vec1, vec2)
{
    return (
        max(vec1[0], vec2[0]),
        max(vec1[1], vec2[1]),
        max(vec1[2], vec2[2])
    );
}

/*
///DocStringBegin
detail: vector_min(vec1: <Vector>, vec2: <Vector>): <Vector>
summary: Returns a vector with the minimum components of vec1 and vec2.
///DocStringEnd
*/
vector_min(vec1, vec2)
{
    return (
        min(vec1[0], vec2[0]),
        min(vec1[1], vec2[1]),
        min(vec1[2], vec2[2])
    );
}

/*
///DocStringBegin
detail: vector_move_towards(current: <Vector>, target: <Vector>, maxDistanceDelta: <Float>): <Vector>
summary: Moves the vector from current towards target by maxDistanceDelta.
///DocStringEnd
*/
vector_move_towards(current, target, maxDistanceDelta)
{
    toVector = vector_subtract(target, current);
    dist = vector_magnitude(toVector);
    
    if (dist <= maxDistanceDelta || dist == 0)
        return target;

    return vector_add(current, vector_scale(toVector, maxDistanceDelta / dist));
}

/*
///DocStringBegin
detail: vector_rotate_towards(current: <Vector>, target: <Vector>, maxRadiansDelta: <Float>): <Vector>
summary: Rotates the vector from current towards target by maxRadiansDelta.
///DocStringEnd
*/
vector_rotate_towards(current, target, maxRadiansDelta)
{
    angle = vector_angle(current, target);
    t = min(1, maxRadiansDelta / angle);
    return vector_lerp(current, target, t);
}

/*
///DocStringBegin
detail: vector_project(vec: <Vector>, onVec: <Vector>): <Vector>
summary: Projects the vector onto another vector.
///DocStringEnd
*/
vector_project(vec, onVec)
{
    return vector_scale(onVec, vector_dot(vec, onVec) / vector_dot(onVec, onVec));
}

/*
///DocStringBegin
detail: vector_project_on_plane(vec: <Vector>, planeNormal: <Vector>): <Vector>
summary: Projects the vector onto a plane defined by the planeNormal.
///DocStringEnd
*/
vector_project_on_plane(vec, planeNormal)
{
    proj = vector_project(vec, planeNormal);
    return vector_subtract(vec, proj);
}

/*
///DocStringBegin
detail: vector_reflect(vec: <Vector>, normal: <Vector>): <Vector>
summary: Reflects the vector off the plane defined by the normal.
///DocStringEnd
*/
vector_reflect(vec, normal)
{
    return vector_subtract(vec, vector_scale(normal, 2 * vector_dot(vec, normal)));
}

/*
///DocStringBegin
detail: vector_ortho_normalize(vec1: <Vector>, vec2: <Vector>): <Array>
summary: Orthonormalizes the given vectors and returns them as an array.
///DocStringEnd
*/
vector_ortho_normalize(vec1, vec2)
{
    vec1 = vector_normalize(vec1);
    proj = vector_project(vec2, vec1);
    vec2 = vector_normalize(vector_subtract(vec2, proj));
    return (vec1, vec2, 0);
}

/*
///DocStringBegin
detail: vector_signed_angle(vec1: <Vector>, vec2: <Vector>, axis: <Vector>): <Float>
summary: Returns the signed angle in degrees between vec1 and vec2 around the given axis.
///DocStringEnd
*/
vector_signed_angle(vec1, vec2, axis)
{
    angle = vector_angle(vec1, vec2);
    crossProduct = vector_cross(vec1, vec2);
    sign = vector_dot(crossProduct, axis);
    if (sign < 0) return -angle;
    return angle;
}

/*
///DocStringBegin
detail: vector_distance(vec1: <Vector>, vec2: <Vector>): <Float>
summary: Returns the distance between vec1 and vec2.
///DocStringEnd
*/
vector_distance(vec1, vec2)
{
    return distance(vec1, vec2);
}

/*
///DocStringBegin
detail: vector_distance_squared(vec1: <Vector>, vec2: <Vector>): <Float>
summary: Returns the squared distance between vec1 and vec2.
///DocStringEnd
*/
vector_distance_squared(vec1, vec2)
{
    return distanceSquared(vec1, vec2);
}

/*
///DocStringBegin
detail: vector_distance2d(vec1: <Vector>, vec2: <Vector>): <Float>
summary: Returns the 2D distance between vec1 and vec2.
///DocStringEnd
*/
vector_distance2d(vec1, vec2)
{
    return distance2d(vec1, vec2);
}

/*
///DocStringBegin
detail: vector_to_angles(vec: <Vector>): <Vector>
summary: Converts the vector to angles.
///DocStringEnd
*/
vector_to_angles(vec)
{
    return vectortoangles(vec);
}

/*
///DocStringBegin
detail: vector_flat_angle(angle: <Vector>): <Vector>
summary: Returns the angle vector with the pitch component set to zero.
///DocStringEnd
*/
vector_flat_angle(angle)
{
    return (0, angle[1], 0);
}

/*
///DocStringBegin
detail: vector_flat_origin(org: <Vector>): <Vector>
summary: Returns the origin vector with the z component set to zero.
///DocStringEnd
*/
vector_flat_origin(org)
{
    return (org[0], org[1], 0);
}

vector_to_euler_angles(forward, up)
{
    forward = vectorNormalize(forward);
    up = vectorNormalize(up);

    right = vector_cross(up, forward);
    right = vectorNormalize(right);

    m00 = forward[0]; m01 = right[0]; m02 = up[0];
    m10 = forward[1]; m11 = right[1]; m12 = up[1];
    m20 = forward[2]; m21 = right[2]; m22 = up[2];

    if (m20 < 1)
    {
        if (m20 > -1)
        {
            pitch = asin(-m20);
            yaw   = math_atan2(m10, m00);
            roll  = math_atan2(m21, m22);
        }
        else
        {
            pitch = 90;
            yaw   = -1 * math_atan2(-m12, m11);
            roll  = 0;
        }
    }
    else
    {
        pitch = -90;
        yaw   = math_atan2(-m12, m11);
        roll  = 0;
    }

    return (pitch, yaw, roll);
}

vector_rotate_around_axis(vec, axis, angle)
{
    axis = vectorNormalize(axis);
    radians = angle * (3.14159 / 180);
    cosA = cos(radians);
    sinA = sin(radians);

    cross = vector_cross(axis, vec);
    dot = vectorDot(axis, vec);

    term1 = vector_scale(vec, cosA);
    term2 = vector_scale(cross, sinA);
    term3 = vector_scale(axis, dot * (1 - cosA));

    return vector_add(vector_add(term1, term2), term3);
}
