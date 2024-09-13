/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : array            |
|Creator : LastDemon99	   |
|Type : Utility            |
============================
*/

array_combine(array_a, array_b)
{
	result = [];
	for (i = 0; i < array_a.size; i++)
		result[i] = array_a[i];
	size = result.size;
	for (i = 0; i < array_b.size; i++)
		result[size + i] = array_b[i];
	return result;
}

array_combine_3(array_a, array_b, array_c)
{
	result = [];
	for (i = 0; i < array_a.size; i++)
		result[i] = array_a[i];
	size = result.size;
	for (i = 0; i < array_b.size; i++)
		result[size + i] = array_b[i];
	size = result.size;
	for (i = 0; i < array_c.size; i++)
		result[size + i] = array_c[i];
	return result;
}

array_combine_4(array_a, array_b, array_c, array_d)
{
	result = [];
	for (i = 0; i < array_a.size; i++)
		result[i] = array_a[i];
	size = result.size;
	for (i = 0; i < array_b.size; i++)
		result[size + i] = array_b[i];
	size = result.size;
	for (i = 0; i < array_c.size; i++)
		result[size + i] = array_c[i];
	size = result.size;
	for (i = 0; i < array_d.size; i++)
		result[size + i] = array_d[i];
	return result;
}

array_unique(array)
{
	result = [];
	seen = [];

    for(i = 0; i < array.size; i++)
		if (!isDefined(seen[array[i]]))
        {
            result[result.size] = array[i];
            seen[array[i]] = true;
        }

	return result;
}

array_union(array_a, array_b)
{
	result = [];
	seen = [];

	for (i = 0; i < array_a.size; i++)
		if (!isDefined(seen[array_a[i]]))
		{
			result[result.size] = array_a[i];
            seen[array_a[i]] = true;
		}

	size = result.size;
	for (i = 0; i < array_b.size; i++)
		if (!isDefined(seen[array_b[i]]))
		{
			result[size + i] = array_b[i];
            seen[array_b[i]] = true;
		}

	return result;
}

array_intersection(array_a, array_b)
{
    result = [];
    seen = [];

    for (i = 0; i < array_b.size; i++)
		seen[array_b[i]] = true;

    for (i = 0; i < array_a.size; i++)
		if (isDefined(seen[array_a[i]]))
			result[result.size] = array_a[i];

    return result;
}

array_difference(array_a, array_b)
{
    result = [];
    seen = [];

    for (i = 0; i < array_b.size; i++)
		seen[array_b[i]] = true;

    for (i = 0; i < array_a.size; i++)
		if (!isDefined(seen[array_a[i]]))
			result[result.size] = array_a[i];

    return result;
}

array_first(array, func, arg1, arg2, arg3, arg4, arg5)
{
	args = [arg1, arg2, arg3, arg4, arg5];
	i_index = _i_index(args);
	a_size = _args_size(args);
	
	for(i = 0; i < array.size; i++)
    {
        if (isDefined(i_index)) args[i_index] = array[i];
        switch(a_size)
        {
			case 0: if ([[func]](array[i])) return array[i]; break;
			case 1: if ([[func]](args[0])) return array[i]; break;
			case 2: if ([[func]](args[0], args[1])) return array[i]; break;
			case 3: if ([[func]](args[0], args[1], args[2])) return array[i]; break;
			case 4: if ([[func]](args[0], args[1], args[2], args[3])) return array[i]; break;
			case 5: if ([[func]](args[0], args[1], args[2], args[3], args[4])) return array[i]; break;
        }
    }
	return undefined;
}

array_index(array, func, arg1, arg2, arg3, arg4, arg5)
{
	args = [arg1, arg2, arg3, arg4, arg5];
	i_index = _i_index(args);
	a_size = _args_size(args);
	
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
	i_index = _i_index(args);
	a_size = _args_size(args);
	
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
	i_index = _i_index(args);
	a_size = _args_size(args);
	
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
	i_index = _i_index(args);
	a_size = _args_size(args);
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
	i_index = _i_index(args);
	a_size = _args_size(args);
	result = [];
	
	for(i = 0; i < array.size; i++)
    {
        if (isDefined(i_index)) args[i_index] = array[i];
        switch(a_size)
        {
			case 0: result[result.size] = [[func]](array[i]); break;
			case 1: result[result.size] = [[func]](args[0]); break;
            case 2: result[result.size] = [[func]](args[0], args[1]); break;
            case 3: result[result.size] = [[func]](args[0], args[1], args[2]); break;
            case 4: result[result.size] = [[func]](args[0], args[1], args[2], args[3]); break;
            case 5: result[result.size] = [[func]](args[0], args[1], args[2], args[3], args[4]); break;
        }
    }
	return result;
}

array_reduce(array, initial_value, func, arg1, arg2, arg3, arg4, arg5)
{
	args = [arg1, arg2, arg3, arg4, arg5];
	i_index = _i_index(args);
	a_size = _args_size(args);
	result = initial_value;
	
	for(i = 0; i < array.size; i++)
    {
        if (isDefined(i_index)) args[i_index] = array[i];
        switch(a_size)
        {
			case 0: result = [[func]](result, array[i]); break;
			case 1: result = [[func]](result, args[0]); break;
            case 2: result = [[func]](result, args[0], args[1]); break;
            case 3: result = [[func]](result, args[0], args[1], args[2]); break;
            case 4: result = [[func]](result, args[0], args[1], args[2], args[3]); break;
            case 5: result = [[func]](result, args[0], args[1], args[2], args[3], args[4]); break;
        }
    }
	return result;
}

array_arange(start, end)
{
	result = [];
	for(i = start; i < end; i++)
		result[result.size] = i;
	return result;
}

array_slice(array, start, end, step)
{
	result = [];
	
	start = isDefined(start) ? start : 0;
	end = isDefined(end) ? end : array.size;
	step = !isDefined(step) || step == 0 ? 1 : step;
	
	if (step > 0)
	{
		for (i = start; i < end && i < array.size; i += step)
			result[result.size] = array[i];
		return result;
	}
	
	if (step < 0)
	{
		end = isDefined(end) ? end : -1;
		for (i = start; i > end && i >= 0; i += step)
			result[result.size] = array[i];
		return result;
	}

	return result;
}

array_from_dvar(dvar, split)
{
	if (!isDefined(split)) split = " ";	
	result = getDvar(dvar);
	
	if (result == "") return [];	
	if (result.size > 2 && isSubStr(result, split)) return strTok(result, split);
	else return [result];
}

array_to_string(array)
{
    return "[" + scripts\lethalbeats\string::string_join(", ", array) + "]";
}

array_print(array)
{
    print("[" + scripts\lethalbeats\string::string_join(", ", array) + "]");
}

array_contains(array, item)
{
	for(i = 0; i < array.size; i++)
		if (array[i] == item)
			return true;
    return false;
}

array_contains_array(array_a, array_b)
{
    return array_intersection(array_a, array_b).size == array_b.size;
}

array_contains_key(array, key)
{
	return isDefined(array[key]);
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

array_append(array, value)
{
	array[array.size] = value;
	return array;
}

array_insert(array, index, value)
{
	result = [];
	count = 0;
	foreach(i in array)
	{
		if (count == index) 
			result[result.size] = value;
		result[result.size] = i;
		count++;
	}
	return result;
}

array_remove(array, value)
{
	result = [];
	foreach(i in array)
		if (i != value)
			result[result.size] = i;
	return result;
}

array_remove_index(array, index)
{
	result = [];
	for (i = 0; i < 0; i++)
		if (i != index)
			result[result.size] = array[i];
	return result;
}

array_remove_key(array, key)
{
	if (!isDefined(array[key])) return array;

	result = [];
	keys = getArrayKeys(array);
	for (i = 0; i < keys.size; i++)
		if (keys[i] != key) result[keys[i]] = array[keys[i]];
	return result;
}

array_get_keys(array)
{
	return getArrayKeys(array);	
}

array_get_values(array)
{
	result = [];
	keys = getArrayKeys(array);
	for (i = 0; i < keys.size; i++)
		result[result.size] = array[keys[i]];
	return result;
}

array_alphabetize(array)
{
	if (array.size <= 1)
		return array;

	count = 0;
	for (i = array.size - 1; i >= 1; i--)
	{
		largest = array[i];
		largestIndex = i;
		for (j = 0; j < i; j++)
		{
			string1 = array[j];
			
			if (strICmp(string1, largest) > 0)
			{
				largest = string1;
				largestIndex = j;
			}
		}
		
		if(largestIndex != i)
		{
			array[largestIndex] = array[i];
			array[i] = largest;
		}
	}

	return array;
}

array_remove_undefined(array)
{
	result = [];
	foreach (item in array)
	{
		if (!isDefined(item)) continue;
		newArray[newArray.size] = item;
	}
	return result;
}

array_reverse(array)
{
	result = [];
	for (i = array.size - 1; i >= 0; i--)
		result[result.size] = array[i];
	return result;
}

array_random_item(array)
{
	result = [];
	foreach (index, value in array)
		result[result.size] = value;

	if (!result.size) return undefined;	
	return result[randomint(result.size)];
}

array_randomize(array)
{
    for (i = array.size - 1; i > 0; i--)
    {
        j = randomInt(i + 1);
        temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
    return array;
}

array_sort(array, ascending)
{
    for (i = 0; i < array.size - 1; i++)
    {
        for (j = i + 1; j < array.size; j++)
        {
            if ((ascending && array[i] > array[j]) || (!ascending && array[i] < array[j]))
            {
                temp = array[i];
                array[i] = array[j];
                array[j] = temp;
            }
        }
    }
    return array;
}

array_merge_sort(array)
{
    if (array.size <= 1) return array;
    mid = int(array.size / 2);
    left = array_merge_sort(array_slice(array, 0, mid));
    right = array_merge_sort(array_slice(array, mid, array.size));
    return array_merge(left, right);
}

array_merge(left, right)
{
    result = [];
    i = 0;
    j = 0;

    while (i < left.size && j < right.size)
    {
        if (left[i] < right[j])
        {
            result[result.size] = left[i];
            i++;
        }
        else
        {
            result[result.size] = right[j];
            j++;
        }
    }

    while (i < left.size)
    {
        result[result.size] = left[i];
        i++;
    }

    while (j < right.size)
    {
        result[result.size] = right[j];
        j++;
    }

    return result;
}

array_quick_sort(array)
{
    if (array.size <= 1)
        return array;

    pivot = array[0];
    left = [];
    right = [];
    for (i = 1; i < array.size; i++)
    {
        if (array[i] <= pivot)
            left[left.size] = array[i];
        else
            right[right.size] = array[i];
    }
    return array_combine_3(array_quick_sort(left), [pivot], array_quick_sort(right));
}

array_index_swap(array, index1, index2) 
{
	temp = array[index1];          
	array[index1] = array[index2];     
	array[index2] = temp;   
	return array;         
}

array_binary_search(array, target)
{
    low = 0;
    high = array.size - 1;

    while (low <= high)
    {
        mid = int((low + high) / 2);

        if (array[mid] == target)
            return mid;
        else if (array[mid] < target)
            low = mid + 1;
        else
            high = mid - 1;
    }
    return undefined;
}

array_chunk(array, size)
{
    chunks = [];
    for (i = 0; i < array.size; i += size)
    {
        chunk = array_slice(array, i, i + size);
        chunks[chunks.size] = chunk;
    }
    return chunks;
}

array_flatten(array)
{
    flat = [];
    for (i = 0; i < array.size; i++)
    {
        if (isArray(array[i]))
            flat = flat + array_flatten(array[i]);
        else
            flat[flat.size] = array[i];
    }
    return flat;
}

array_min(array)
{
    min = array[0];
    for (i = 1; i < array.size; i++)
    {
        if (array[i] < min)
            min = array[i];
    }
    return min;
}

array_max(array)
{
    max = array[0];
    for (i = 1; i < array.size; i++)
    {
        if (array[i] > max)
            max = array[i];
    }
    return max;
}

array_is_blank(array) 
{ 
	return !isDefined(array) || array.size == 0; 
}

filter_equal(i, arg1)
{ 
	return i == arg1; 
}

filter_not_equal(i, arg1) 
{ 
	return i != arg1; 
}

i()
{
	return "{i}";
}

_i_index(args)
{
	for(i = 0; i < 5; i++)
		if (isString(args[i]) && args[i] == "{i}") return i;
	return 0;
}

_args_size(args)
{
	last_defined = 0;
	for(i = 0; i < 5; i++)
		if (isDefined(args[i])) last_defined = i + 1;
	return last_defined;
}
