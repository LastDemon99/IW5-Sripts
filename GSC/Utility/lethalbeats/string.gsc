/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : string           |
|Creator : LastDemon99	   |
|Type : Utility            |
============================
*/

/*
///DocStringBegin
detail: string_length(string: <String>): <Int>
summary: Returns the length of the given string.
///DocStringEnd
*/
string_length(string)
{
    return string.size;
}

/*
///DocStringBegin
detail: string_slice(string: <String>, start?: <Int>, end?: <Int>, step?: <Int>): <String>
summary: Returns a substring of the given string from start to end with the specified step.
///DocStringEnd
*/
string_slice(string, start, end, step)
{
    result = "";    
    if (!isDefined(step) || step == 0) step = 1;

    if (step > 0)
    {
        if (!isDefined(start)) start = 0;
        if (!isDefined(end)) end = string.size;
        
        for (i = start; i < end && i < string.size; i += step)
            result += string[i];
    }
    else
    {
        if (!isDefined(start) || start >= string.size) start = string.size - 1;
        if (!isDefined(end)) end = -1;
        
        for (i = start; i >= end && i >= 0; i += step)
            result += string[i];
    }
    return result;
}

/*
///DocStringBegin
detail: string_upper(string: <String>): <String>
summary: Converts all characters in the given string to uppercase.
///DocStringEnd
*/
string_upper(string)
{
    return toUpper(string);
}

/*
///DocStringBegin
detail: string_lower(string: <String>): <String>
summary: Converts all characters in the given string to lowercase.
///DocStringEnd
*/
string_lower(string)
{
    return tolower(string);
}

/*
///DocStringBegin
detail: string_capitalize(string: <String>): <String>
summary: Capitalizes the first character of the given string.
///DocStringEnd
*/
string_capitalize(string)
{
    return toUpper(string[0]) + string_slice(string, 1, string.size);
}

/*
///DocStringBegin
detail: string_compare(string_a: <String>, string_b: <String>): <Bool>
summary: Compares two strings case-insensitively. Returns true if they are equal.
///DocStringEnd
*/
string_compare(string_a, string_b) // insensitive
{
    return strICmp(string_a, string_b) == 0;
}

/*
///DocStringBegin
detail: string_is_later_in_alphabet(string_a: <String>, string_b: <String>): <Bool>
summary: Checks if string_a is later in the alphabet than string_b.
///DocStringEnd
*/
string_is_later_in_alphabet(string_a, string_b)
{
    return strICmp(string_a, string_b) > 0;
}

/*
///DocStringBegin
detail: string_reverse(string: <String>): <String>
summary: Reverses the given string.
///DocStringEnd
*/
string_reverse(string)
{
    reverse = "";
    for (i = string.size - 1; i > -1; i--)
        reverse += string[i];
    return reverse;
}

/*
///DocStringBegin
detail: string_contains(string: <String>, substring: <String>): <Bool>
summary: Checks if the given string contains the specified substring.
///DocStringEnd
*/
string_contains(string, substring)
{
    return isSubStr(string, substring);
}

/*
///DocStringBegin
detail: string_starts_with(string: <String>, start: <String>): <Bool>
summary: Checks if the given string starts with the specified substring.
///DocStringEnd
*/
string_starts_with(string, start)
{
    return getsubstr(string, 0, start.size) == start;
}

/*
///DocStringBegin
detail: string_ends_with(string: <String>, end: <String>): <Bool>
summary: Checks if the given string ends with the specified substring.
///DocStringEnd
*/
string_ends_with(string, end)
{
    return isEndStr(string, end);	
}

/*
///DocStringBegin
detail: string_split(string: <String>, split?: <String>): <Array>
summary: Splits the given string by the specified delimiter. If no delimiter is provided, splits by whitespace.
///DocStringEnd
*/
string_split(string, split)
{
    if (!isDefined(split)) return string_to_array(string);
    return strtok(string, split);
}

/*
///DocStringBegin
detail: string_join(string: <String>, array: <Array>): <String>
summary: Joins the elements of the array into a single string, separated by the given string.
///DocStringEnd
*/
string_join(string, array)
{
    result = "";
    for(i = 0; i < array.size; i++)
    {
        if (!isDefined(array[i])) array[i] = "undefined";
        if (i == 0) result += array[i];
        else result += string + array[i];
    }
    return result;
}

/*
///DocStringBegin
detail: string_replace(string: <String>, target: <String>, new_string: <String>): <String>
summary: Replaces all occurrences of the target substring with the new substring in the given string.
///DocStringEnd
*/
string_replace(string, target, new_string)
{
    if (!isDefined(string)) return "";

    result = "";
    i = 0;

    while (i < string.size)
    {
        match = true;
        for (j = 0; j < target.size; j++)
        {
            if (i + j >= string.size || string[i + j] != target[j])
            {
                match = false;
                break;
            }
        }

        if (match)
        {
            result += new_string;
            i += target.size;
        }
        else
        {
            result += string[i];
            i++;
        }
    }
    return result;
}

/*
///DocStringBegin
detail: string_replace_prefix(string: <String>, prefix: <String>, new_prefix: <String>): <String>
summary: Replace the specified prefix from the beginning of the given string if it exists.
///DocStringEnd
*/
string_replace_prefix(string, prefix, new_prefix)
{
    if (!string_starts_with(string, prefix)) return string;
    return new_prefix + getSubStr(string, prefix.size, string.size);
}

/*
///DocStringBegin
detail: string_replace_suffix(string: <String>, suffix: <String>, new_suffix: <String>): <String>
summary: Replace the specified suffix from the end of the given string if it exists.
///DocStringEnd
*/
string_replace_suffix(string, suffix, new_suffix)
{
    if (!string_ends_with(string, suffix)) return string;
    return getSubStr(string, 0, string.size - suffix.size) + new_suffix;
}

/*
///DocStringBegin
detail: string_remove(string: <String>, target: <String>): <String>
summary: Removes all occurrences of the target substring from the given string.
///DocStringEnd
*/
string_remove(string, target)
{
    return string_replace(string, target, "");
}

/*
///DocStringBegin
detail: string_remove_prefix(string: <String>, prefix: <String>): <String>
summary: Removes the specified prefix from the beginning of the given string if it exists.
///DocStringEnd
*/
string_remove_prefix(string, prefix)
{
    return string_replace_prefix(string, prefix, "");
}

/*
///DocStringBegin
detail: string_remove_suffix(string: <String>, suffix: <String>): <String>
summary: Removes the specified suffix from the end of the given string if it exists.
///DocStringEnd
*/
string_remove_suffix(string, suffix)
{
    return string_replace_suffix(string, suffix, "");
}

/*
///DocStringBegin
detail: string_trim(string: <String>): <String>
summary: Removes all spaces from the given string.
///DocStringEnd
*/
string_trim(string)
{
    return string_replace(string, " ", "");
}

/*
///DocStringBegin
detail: string_trim_left(string: <String>): <String>
summary: Removes leading spaces from the given string.
///DocStringEnd
*/
string_trim_left(string)
{
    i = 0;
    while (string[i] == " ") 
        i++;

    if (i == string.size) return "";

    return string_slice(string, i, string.size);
}

/*
///DocStringBegin
detail: string_trim_right(string: <String>): <String>
summary: Removes trailing spaces from the given string.
///DocStringEnd
*/
string_trim_right(string)
{
    i = string.size - 1;
    while (string[i] == " ") 
        i--;

    if (i == string.size - 1) return "";

    return string_slice(string, 0, i + 1);
}

/*
///DocStringBegin
detail: string_repeat(string: <String>, count: <Int>): <String>
summary: Repeats the given string the specified number of times.
///DocStringEnd
*/
string_repeat(string, count)
{
    result = "";
    for(i = 0; i < count; i++)
        result += string;
    return result;
}

/*
///DocStringBegin
detail: string_pad_left(string: <String>, pad: <String>, count: <Int>): <String>
summary: Pads the given string on the left with the specified pad string, repeated the specified number of times.
///DocStringEnd
*/
string_pad_left(string, count, pad)
{
    return string_repeat(pad, count) + string;
}

/*
///DocStringBegin
detail: string_pad_right(string: <String>, pad: <String>, count: <Int>): <String>
summary: Pads the given string on the right with the specified pad string, repeated the specified number of times.
///DocStringEnd
*/
string_pad_right(string, pad, count)
{
    return string + string_repeat(pad, count);
}

/*
///DocStringBegin
detail: string_get_substring(string: <String>, start: <Int>, end: <Int>): <String>
summary: Returns the substring of the given string from start to end.
///DocStringEnd
*/
string_get_substring(string, start, end)
{
    return getSubstr(string, start, end);
}

/*
///DocStringBegin
detail: string_index_of(string: <String>, substring: <String>, occurrence?: <Int>): <Int?>
summary: Returns the index of the nth occurrence of the specified substring in the given string. If occurrence is not specified, defaults to 1.
///DocStringEnd
*/
string_index_of(string, substring, occurrence)
{
    if (!isDefined(occurrence)) occurrence = 1;
    i = 0;
    count = 0;    
    while (i < string.size)
    {
        match = true;
        for (j = 0; j < substring.size; j++)
        {
            if (i + j >= string.size || string[i + j] != substring[j])
            {
                match = false;
                break;
            }
        }
        
        if (match)
        {
            count++;
            if (count == occurrence)
                return i;
        }        
        i++;
    }    
    return undefined;
}

/*
///DocStringBegin
detail: string_count(string: <String>, substring: <String>): <Int>
summary: Returns the number of occurrences of the specified substring in the given string.
///DocStringEnd
*/
string_count(string, substring)
{
    i = 0;
    count = 0;    
    while (i < string.size)
    {
        match = true;
        for (j = 0; j < substring.size; j++)
        {
            if (i + j >= string.size || string[i + j] != substring[j])
            {
                match = false;
                break;
            }
        }        
        if (match) count++;       
        i++;
    }
    return count;
}

/*
///DocStringBegin
detail: string_is_blank(string: <String>): <Bool>
summary: Checks if the given string is blank (undefined, empty, or only contains spaces).
///DocStringEnd
*/
string_is_blank(string)
{
    return !isDefined(string) || string == "" || string_count(string, " ") == string.size;
}

/*
///DocStringBegin
detail: string_to_array(string: <String>): <Array>
summary: Converts the given string to an array of characters.
///DocStringEnd
*/
string_to_array(string)
{
    result = [];
    for(i = 0; i < string.size; i++)
        result[i] = string[i];
    return result;
}
