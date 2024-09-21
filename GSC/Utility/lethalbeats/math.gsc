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
/*
///DocStringBegin
detail: math_sum(a: <Number>, b: <Number>): <Number>
summary: Calculates the sum of two numbers and returns the result.
///DocStringEnd
*/
math_sum(a, b)
{
    return a + b;
}

/*
///DocStringBegin
detail: math_min(a: <Number>, b: <Number>): <Number>
summary: Returns the smaller of two numbers.
///DocStringEnd
*/
math_min(a, b)
{
    return min(a, b);
}

/*
///DocStringBegin
detail: math_max(a: <Number>, b: <Number>): <Number>
summary: Returns the larger of two numbers.
///DocStringEnd
*/
math_max(a, b)
{
    return max(a, b);
}

/*
///DocStringBegin
detail: math_abs(x: <Number>): <Number>
summary: Returns the absolute value of a number.
///DocStringEnd
*/
math_abs(x)
{
    return abs(x);
}

/*
///DocStringBegin
detail: math_clamp(value: <Number>, min: <Number>, max: <Number>): <Number>
summary: Clamps a number between a minimum and maximum value.
///DocStringEnd
*/
math_clamp(value, min, max)
{
    return clamp(value, min, max);
}

/*
///DocStringBegin
detail: math_cos(angle: <Number>): <Number>
summary: Returns the cosine of an angle.
///DocStringEnd
*/
math_cos(angle)
{
    return cos(angle);
}

/*
///DocStringBegin
detail: math_acos(angle: <Number>): <Number>
summary: Returns the arccosine of an angle.
///DocStringEnd
*/
math_acos(angle)
{
    return acos(angle);
}

/*
///DocStringBegin
detail: math_sin(angle: <Number>): <Number>
summary: Returns the sine of an angle.
///DocStringEnd
*/
math_sin(angle)
{
    return sin(angle);
}

/*
///DocStringBegin
detail: math_asin(x: <Number>): <Number>
summary: Returns the arcsine of a number.
///DocStringEnd
*/
math_asin(x)
{
    return asin(x);
}

/*
///DocStringBegin
detail: math_tan(angle: <Number>): <Number>
summary: Returns the tangent of an angle.
///DocStringEnd
*/
math_tan(angle)
{
    return tan(angle);
}

/*
///DocStringBegin
detail: math_atan(angle: <Number>): <Number>
summary: Returns the arctangent of an angle.
///DocStringEnd
*/
math_atan(angle)
{
    return atan(angle);
}

/*
///DocStringBegin
detail: math_atan2(y: <Number>, x: <Number>): <Number>
summary: Returns the arctangent of the quotient of its arguments.
///DocStringEnd
*/
math_atan2(y, x)
{
    if (x > 0) return atan(y / x);
    if (x < 0 && y >= 0) return atan(y / x) + 180;
    if (x < 0 && y < 0) return atan(y / x) - 180;
    if (x == 0 && y > 0)  return 90;
    if (x == 0 && y < 0) return -90;
    return 0;
}

/*
///DocStringBegin
detail: math_sign(x: <Number>): <Number>
summary: Returns the sign of a number.
///DocStringEnd
*/
math_sign(x)
{
    if (x > 0) return 1;
    if (x < 0) return -1;
    return 0;
}

/*
///DocStringBegin
detail: math_squared(x: <Number>): <Number>
summary: Returns the square of a number.
///DocStringEnd
*/
math_squared(x)
{
    return squared(x);
}

/*
///DocStringBegin
detail: math_length_squared(x: <Number>, y: <Number>, z: <Number>): <Number>
summary: Returns the squared length of a 3D vector.
///DocStringEnd
*/
math_length_squared(x, y, z)
{
    return x * x + y * y + z * z;
}

/*
///DocStringBegin
detail: math_pow(base: <Number>, exponent: <Number>): <Number>
summary: Returns the base raised to the power of exponent.
///DocStringEnd
*/
math_pow(base, exponent)
{
    result = 1;
    for (i = 0; i < exponent; i++)
        result *= base;
    return result;
}

/*
///DocStringBegin
detail: math_sqrt(x: <Number>): <Number>
summary: Returns the square root of a number.
///DocStringEnd
*/
math_sqrt(x)
{
    return sqrt(x);
}

/*
///DocStringBegin
detail: math_mean(array: <Array>): <Number>
summary: Returns the mean (average) of an array of numbers.
///DocStringEnd
*/
math_mean(array)
{
    return array_reduce(array, 0, ::math_sum) / array.size;
}

/*
///DocStringBegin
detail: math_median(array: <Array>): <Number>
summary: Returns the median of an array of numbers.
///DocStringEnd
*/
math_median(array)
{
    sortedArray = array_quick_sort(array);
    mid = sortedArray.size / 2;

    if (sortedArray.size % 2 == 0)
        return (sortedArray[mid - 1] + sortedArray[mid]) / 2;
    else
         return sortedArray[mid];
}

/*
///DocStringBegin
detail: math_mode(array: <Array>): <Number?>
summary: Returns the mode of an array of numbers. If no mode exists, returns undefined.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: math_range(array: <Array>): <Number>
summary: Returns the range (difference between the largest and smallest values) of an array of numbers.
///DocStringEnd
*/
math_range(array)
{
    sortedArray = array_quick_sort(array);
    return sortedArray[sortedArray.size - 1] - sortedArray[0];
}

/*
///DocStringBegin
detail: math_variance(array: <Array>): <Number>
summary: Returns the variance of an array of numbers.
///DocStringEnd
*/
math_variance(array)
{
    mean = math_mean(array);
    sumOfSquares = 0;

    foreach(i in array)
        sumOfSquares += squared(i - mean);

    return sumOfSquares / array.size;
}

/*
///DocStringBegin
detail: math_std(array: <Array>): <Number>
summary: Returns the standard deviation of an array of numbers.
///DocStringEnd
*/
math_std(array)
{
    return sqrt(math_variance(array));
}

/*
///DocStringBegin
detail: math_lerp(a: <Number>, b: <Number>, t: <Number>): <Number>
summary: Performs a linear interpolation between two values.
///DocStringEnd
*/
math_lerp(a, b, t)
{
    return a + (b - a) * t;
}

/*
///DocStringBegin
detail: math_smoothstep(a: <Number>, b: <Number>, t: <Number>): <Number>
summary: Performs a smooth interpolation between two values.
///DocStringEnd
*/
math_smoothstep(a, b, t)
{
    t = clamp(t, 0, 1);
    t = t * t * (3 - 2 * t);
    return math_lerp(a, b, t);
}

/*
///DocStringBegin
detail: math_pi(): <Number>
summary: Returns the value of Pi.
///DocStringEnd
*/
math_pi()
{
    return 3.14159265358979;
}

/*
///DocStringBegin
detail: math_cointoss(): <Bool>
summary: Simulates a coin toss. Returns true for heads and false for tails.
///DocStringEnd
*/
math_cointoss()
{
    return randomint(100) >= 50;
}

/*
///DocStringBegin
detail: math_angle_clamp_180(angle: <Number>): <Number>
summary: Clamps an angle to the range [-180, 180] degrees.
///DocStringEnd
*/
math_angle_clamp_180(angle)
{
    return angleClamp180(angle);
}

/*
///DocStringBegin
detail: math_angle_diff(oldangle: <Number>, newangle: <Number>): <Number>
summary: Returns the absolute difference between two angles.
///DocStringEnd
*/
math_angle_diff(oldangle, newangle)
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

/*
///DocStringBegin
detail: math_truncate(number: <Number>, decimals: <Number>): <Number>
summary: Truncates a number to a specified number of decimal places.
///DocStringEnd
*/
math_truncate(number, decimals)
{
    factor = math_pow(10, decimals);
    return floor(number * factor) / factor;
}

/*
///DocStringBegin
detail: math_round(number: <Number>, decimals: <Number>): <Number>
summary: Rounds a number to a specified number of decimal places.
///DocStringEnd
*/
math_round(number, decimals)
{
    factor = math_pow(10, decimals);
    return floor((number * factor) + 0.5) / factor;
}

/*
///DocStringBegin
detail: math_degrees_to_radians(degrees: <Number>): <Number>
summary: Converts degrees to radians.
///DocStringEnd
*/
math_degrees_to_radians(degrees)
{
    return degrees * (math_pi() / 180.0);
}

/*
///DocStringBegin
detail: math_radians_to_degrees(radians: <Number>): <Number>
summary: Converts radians to degrees.
///DocStringEnd
*/
math_radians_to_degrees(radians) 
{
    return radians * (180.0 / math_pi());
}
