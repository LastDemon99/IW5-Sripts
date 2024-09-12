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

string_length(string)
{
    return string.size;
}

string_slice(string, start, end, step)
{
	result = "";	
	start = isDefined(start) ? start : 0;
	end = isDefined(end) ? end : string.size;
	step = !isDefined(step) || step == 0 ? 1 : step;
	
	if (step > 0)
	{
		for (i = start; i < end && i < string.size; i += step)
			result += string[i];
		return result;
	}
	
	if (step < 0)
	{
		end = isDefined(end) ? end : -1;
		for (i = start; i > end && i >= 0; i += step)
			result += string[i];
		return result;
	}

	return result;
}

string_upper(string)
{
    return toUpper(string);
}

string_lower(string)
{
    return tolower(string);
}

string_capitalize(string)
{
    return toUpper(string[0]) + string_slice(string, 1, string.size);
}

string_compare(string_a, string_b) // insensitive
{
    return strICmp(string_a, string_b) == 0;
}

string_is_later_in_alphabet()
{
    return strICmp(string_a, string_b) > 0;
}

string_reverse(string)
{
	reverse = "";
	for (i = string.size - 1; i > -1; i--)
		reverse += string[i];
	return reverse;
}

string_contains(string, substring)
{
    return isSubStr(string, substring);
}

string_starts_with(string, start) // string_starts_with is in common_scripts\utility... equal to issuffix?? wtf, and... isStrStart in maps\mp\_utility (-_-|||)
{
	if (string.size < start.size)
		return false;

	for (i = 0 ; i < start.size ; i++)
        if (!string_compare(string[i], start[i]))
			return false;

	return true;
}

string_ends_with(string, end)
{
	if (string.size < end.size)
		return false;
	
	end = string_reverse(end);
	for (i = 0; i < end.size; i++)
	{
        if (!string_compare(string[string.size - i - 1], end[i]))
			return false;
	}
	return true;	
}

string_split(string, split)
{
    if (!isDefined(split)) return string_to_array(string);
    return strtok(string, split);
}

string_join(string, array)
{
	result = "";
	for(i = 0; i < array.size; i++)
		if (i == 0) result += array[i];
		else result += string + array[i];
	return result;
}

string_replace(string, target, new_string)
{
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

string_trim(string)
{
    return string_replace(string, " ", "");
}

string_trim_left(string)
{
    i = 0;
    while (string[i] == " ") 
        i++;

    if (i == string.size) return "";

    return string_slice(string, i, string.size);
}

string_trim_right(string)
{
    i = string.size - 1;
    while (string[i] == " ") 
        i--;

    if (i == string.size - 1) return "";

    return string_slice(string, 0, i + 1);
}

string_repeat(string, count)
{
    result = "";
    for(i = 0; i < count; i++)
        result += string;
    return result;
}

string_pad_left(string, pad, count)
{
    return string_repeat(pad, count) + string;
}

string_pad_right(string, pad, count)
{
    return string + string_repeat(pad, count);
}

string_get_substring(string, start, end)
{
    return getSubstr(string, start, end);
}

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

string_is_blank(string)
{
    return !isDefined(string) || string == "" || string_count(string, " ") == string.size;
}

string_to_array(string)
{
    result = [];
    for(i = 0; i < string.size; i++)
        result[i] = string[i];
    return result;
}

string_compare(string_a, string_b)
{
    return string_a == string_b;
}
