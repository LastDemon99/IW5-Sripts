/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : math             |
|Creator : LastDemon99	   |
|Type : Utility            |
============================
*/

#include scripts\lethalbeats\array;

math_sum(a, b)
{
	return a + b;
}

math_min(a, b)
{
    return min(a, b);
}

math_max(a, b)
{
    return max(a, b);
}

math_abs(x)
{
    return abs(x);
}

math_clamp(value, min, max)
{
    return clamp(value, min, max);
}

math_cos(angle)
{
    return cos(angle);
}

math_acos(angle)
{
    return acos(angle);
}

math_sin(angle)
{
    return sin(angle);
}

math_asin(x)
{
    return asin(x);
}

math_tan(angle)
{
    return tan(angle);
}

math_atan(angle)
{
    return atan(angle);
}

math_atan2(y, x)
{
    if (x > 0) return atan(y / x);
    if (x < 0 && y >= 0) return atan(y / x) + 180;
    if (x < 0 && y < 0) return atan(y / x) - 180;
    if (x == 0 && y > 0)  return 90;
    if (x == 0 && y < 0) return -90;
    return 0;
}

math_sign(x)
{
    if (x > 0) return 1;
    if (value < 0) return -1;
    return 0;
}

math_squared(x)
{
    return squared(x);
}

math_length_squared(x, y, z)
{
    return x * x + y * y + z * z;
}

math_power(base, exponent)
{
    result = 1;
    for (i = 0; i < exponent; i++)
        result *= base;
    return result;
}

math_sqrt(x)
{
    return sqrt(x);
}

math_mean(array)
{
    return array_reduce(array, 0, ::math_sum) / array.size;
}

math_median(array)
{
    sortedArray = array_quick_sort(array);
    mid = sortedArray.size / 2;

    if (sortedArray.size % 2 == 0)
        return (sortedArray[mid - 1] + sortedArray[mid]) / 2;
    else
         return sortedArray[mid];
}

math_mode(array)
{
    frequency = [];
    maxFreq = 0;
    mode = undefined;

    foreach(i in array)
    {
        if (isDefined(frequency[i]))
            frequency[i] += 1;
        else
            frequency[i] = 1;

        if (frequency[i] > maxFreq)
        {
            maxFreq = frequency[i];
            mode = i;
        }
    }

    return mode;
}

math_range(array)
{
    sortedArray = array_quick_sort(array);
    return sortedArray[sortedArray.size - 1] - sortedArray[0];
}

math_variance(array)
{
    mean = math_mean(array);
    sumOfSquares = 0;

    foreach(i in array)
        sumOfSquares += squared(i - mean);

    return sumOfSquares / array.size;
}

math_std(array)
{
    return sqrt(math_variance(array));
}

math_lerp(a, b, t)
{
    return a + (b - a) * t;
}

math_smoothstep(a, b, t)
{
    t = clamp(t, 0, 1);
    t = t * t * (3 - 2 * t);
    return math_lerp(a, b, t);
}

math_pi()
{
    return 3.14159;
}

math_cointoss()
{
	return randomint(100) >= 50;
}

math_angle_clamp_180(angle)
{
    return angleClamp180(angle);
}

math_angle_dif(oldangle, newangle)
{
    oldangle = oldangle % 360;
    newangle = newangle % 360;
    
    if (oldangle < 0)
        oldangle += 360;

    if (newangle < 0)
        newangle += 360;

    dif = newangle - oldangle;

    if (dif > 180) dif -= 360;
    else if (dif < -180) dif += 360;

    return abs(dif);
}
