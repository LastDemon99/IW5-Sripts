#include common_scripts\utility;
#include maps\mp\_utility;

/*
=========================
	String Region
=========================
*/

string_reverse(string)
{
	reverse = "";
	for (i = string.size - 1; i > -1; i--)
		reverse += string[i];
	return reverse;
}

string_end_with(string, end)
{
	if (string.size < end.size)
		return false;
	
	end = string_reverse(end);
	for (i = 0; i < end.size; i++)
	{
		if (tolower(string[string.size - i - 1]) != tolower(end[i]))
			return false;
	}
	return true;	
}

string_replace(string, target, new_string)
{
	result = "";
    i = 0;
	
    while(i < string.size)
    {
		match = true;
		
        for(j = 0; j < target.size; j++)
            if (i + j >= string.size || string[i + j] != target[j])
            {
				match = false;
                break;
			}
				
        if (match)
        {
			result += new_string;
            i += target.size;
		}
        else
		{
			result += string[i];
            i += 1;
		}
	}
    return result;
}

string_array_join(string, array)
{
	result = "";
	for(i = 0; i < array.size; i++)
		if (i == 0) result += array[i];
		else result += string + array[i];
	return result;
}

//string_starts_with
//isSubStr
//issuffix
//strip_suffix
//GetSubStr
//isstring

/*
=========================
	Array Region
=========================
*/

array_unique(array)
{
	result = [];
    for(i = 0; i < array.size; i++)
		if (!array_contains(result, array[i]))
			result[result.size] = array[i];
	return result;
}

array_union(array_a, array_b)
{
    return array_unique(array_unique(array_a), array_b);
}

array_intersection(array_a, array_b)
{
    result = [];
    for(i = 0; i < array_a.size; i++)
		if (array_contains(array_b, array_a[i]))
			result[result.size] = array_a[i];    
    return result;
}

array_difference(array_a, array_b)
{
    result = [];    
    for(i = 0; i < array_a.size; i++)
		if (!array_contains(array_b, array_a[i]))
			result[result.size] = array_a[i];    
    return result;
}

array_index(array, func, arg1, arg2, arg3, arg4, arg5)
{
	args = [arg1, arg2, arg3, arg4, arg5];
	i_index = i_index(args);
	a_size = args_size(args);
	result = [];
	
	for(i = 0; i < array.size; i++)
    {
        if (isDefined(i_index)) args[i_index] = array[i];
        switch(a_size)
        {
			case 0: if ([[func]](array[i])) return i; break;
			case 1: if ([[func]](args[0])) return i; break;
			case 2: if ([[func]](args[0], args[1])) return i; break;
			case 3: if ([[func]](args[0], args[1], args[2])) return i; break;
			case 4: if ([[func]](args[0], args[1], args[2], args[3])) return i; break;
			case 5: if ([[func]](args[0], args[1], args[2], args[3], args[4])) return i; break;
        }
    }
	return undefined;
}

array_any(array, func, arg1, arg2, arg3, arg4, arg5)
{
	args = [arg1, arg2, arg3, arg4, arg5];
	i_index = i_index(args);
	a_size = args_size(args);
	result = [];
	
	for(i = 0; i < array.size; i++)
    {
        if (isDefined(i_index)) args[i_index] = array[i];
        switch(a_size)
        {
			case 0: if ([[func]](array[i])) return true; break;
			case 1: if ([[func]](args[0])) return true; break;
			case 2: if ([[func]](args[0], args[1])) return true; break;
			case 3: if ([[func]](args[0], args[1], args[2])) return true; break;
			case 4: if ([[func]](args[0], args[1], args[2], args[3])) return true; break;
			case 5: if ([[func]](args[0], args[1], args[2], args[3], args[4])) return true; break;
        }
    }
	return false;
}

array_all(array, func, arg1, arg2, arg3, arg4, arg5)
{
	args = [arg1, arg2, arg3, arg4, arg5];
	i_index = i_index(args);
	a_size = args_size(args);
	result = [];
	
	for(i = 0; i < array.size; i++)
    {
        if (isDefined(i_index)) args[i_index] = array[i];
        switch(a_size)
        {
			case 0: if (![[func]](array[i])) return false; break;
			case 1: if (![[func]](args[0])) return false; break;
			case 2: if (![[func]](args[0], args[1])) return false; break;
			case 3: if (![[func]](args[0], args[1], args[2])) return false; break;
			case 4: if (![[func]](args[0], args[1], args[2], args[3])) return false; break;
			case 5: if (![[func]](args[0], args[1], args[2], args[3], args[4])) return false; break;
        }
    }
	return true;
}

array_filter(array, func, arg1, arg2, arg3, arg4, arg5)
{	
	args = [arg1, arg2, arg3, arg4, arg5];
	i_index = i_index(args);
	a_size = args_size(args);
	result = [];
	
	for(i = 0; i < array.size; i++)
    {
        if (isDefined(i_index)) args[i_index] = array[i];
        switch(a_size)
        {
			case 0: if ([[func]](array[i])) result[result.size] = array[i]; break;
			case 1: if ([[func]](args[0])) result[result.size] = array[i]; break;
			case 2: if ([[func]](args[0], args[1])) result[result.size] = array[i]; break;
			case 3: if ([[func]](args[0], args[1], args[2])) result[result.size] = array[i]; break;
			case 4: if ([[func]](args[0], args[1], args[2], args[3])) result[result.size] = array[i]; break;
			case 5: if ([[func]](args[0], args[1], args[2], args[3], args[4])) result[result.size] = array[i]; break;
        }
    }
	return result;
}

array_map(array, func, arg1, arg2, arg3, arg4, arg5)
{
	args = [arg1, arg2, arg3, arg4, arg5];
	i_index = i_index(args);
	a_size = args_size(args);
	result = [];
	
	for(i = 0; i < array.size; i++)
    {
        if (isDefined(i_index)) args[i_index] = array[i];
        switch(a_size)
        {
			case 0: result[result.size] = [[func]](); break;
			case 1: result[result.size] = [[func]](args[0]); break;
            case 2: result[result.size] = [[func]](args[0], args[1]); break;
            case 3: result[result.size] = [[func]](args[0], args[1], args[2]); break;
            case 4: result[result.size] = [[func]](args[0], args[1], args[2], args[3]); break;
            case 5: result[result.size] = [[func]](args[0], args[1], args[2], args[3], args[4]); break;
        }
    }
	return result;
}

array_arange(start, end)
{
	new_array = [];
	for(i = start; i < end; i++)
		new_array[new_array.size] = i;
	return new_array;
}

array_slice(array, start, end, step)
{
	new_array = [];
	
	i = isDefined(start) ? start : 0;
	end = isDefined(end) ? end : array.size;
	step = !isDefined(step) || step == 0 ? 1 : step;	
	
	if (step > 0)
	{
        for(; i < end; i += step)
			new_array[new_array.size] = array[i];
		return new_array;
	}
	
	step *= -1;	
	for(; i <= end; i += step)
		new_array[new_array.size] = array[array.size - i];
	return new_array;
}

array_from_dvar(dvar, split)
{
	if (!isDefined(split)) split = " ";	
	result = getDvar(dvar);
	
	if (result == "") return [];	
	if (result.size > 2 && isSubStr(result, split)) return strTok(result, split);
	else return [result];
}

array_print(array)
{
    print("[" + string_array_join(", ", array) + "]");
}

array_contains(array, item)
{
	for(i = 0; i < array.size; i++)
		if (array[i] == item)
			return true;
    return false;
}

array_contains_array(array, items)
{
	for(i = 0; i < items.size; i++)
		if (!array_contains(array, items[i]))
			return false;
    return true;
}

array_contains_key(array, key)
{
	return array_contains(getarraykeys(array), key);
}

array_random_int_unique(size, min, max)
{
	uniqueArray = [size];
	random = 0;

	for (i = 0; i < size; i++)
	{
		random = randomIntRange(min, max);
		for (j = i; j >= 0; j--)
			if (isDefined(uniqueArray[j]) && uniqueArray[j] == random)
			{
				random = randomIntRange(min, max);
				j = i;
			}
		uniqueArray[i] = random;
	}
	return uniqueArray;
}

array_remove_index(array, index) //array_remove_index is already defined on maps\mp\killstreaks\_ac130
{
	newArray = [];
	keys = getArrayKeys(array);
	for (i = keys.size - 1; i >= 0; i--)
		if (keys[i] != index) newArray[newArray.size] = array[keys[i]];
	return newArray;
}

arrays_combine(arrays)
{
	result = [];
	for(i = 0; i < arrays.size; i++)
	{
		array = arrays[i];
		for(j = 0; j < array.size; j++) result[result.size] = array[j];
	}
	return result;
}

array_is_blank(array) { return !isDefined(array) || array.size == 0; }

i_index(args)
{
	for(i = 0; i < 5; i++)
		if (isString(args[i]) && args[i] == "{i}") return i;
	return undefined;
}

args_size(args)
{
	last_defined = 0;
	for(i = 0; i < 5; i++)
		if (isDefined(args[i])) last_defined = i + 1;
	return last_defined;
}

//array_remove
//array_removeUndefined
//array_remove_array
//array_combine
//add_to_array

/*
=========================
	Random Stuff Region
=========================
*/

player_is_infect(player)
{
	return getDvar("g_gametype") == "infect" && player.sessionTeam == "axis";
}

equal_filter(i, arg1) { return i == arg1; }

not_equal_filter(i, arg1) { return i != arg1; }

blank(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) {}

returnFalse() { return false; }

returnTrue() { return true; }

/*
=========================
	Maths Region
=========================
*/

vector_scale(vec, scale)
{
	return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}
