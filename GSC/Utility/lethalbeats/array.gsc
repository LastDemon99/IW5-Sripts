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

/*
///DocStringBegin
detail: array_combine(<Array>: array_a, <Array>: array_b): array
summary: Combines the two arrays and returns the resulting array. This function doesn't care if it produces duplicates
///DocStringEnd
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

/*
///DocStringBegin
detail: array_combine(<Array>: array_a, <Array>: array_b, <Array>: array_c): array
summary: Combines the two arrays and returns the resulting array. This function doesn't care if it produces duplicates
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_combine(<Array>: array_a, <Array>: array_b, <Array>: array_c, <Array>: array_d): array
summary: Combines the two arrays and returns the resulting array. This function doesn't care if it produces duplicates
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_to_dictionary(<Array>: array_a, <Array>: array_b): dictionary
summary: Converts two arrays into a dictionary where elements of the first array become keys, and elements of the second array become the corresponding values.
///DocStringEnd
*/
array_to_dictionary(array_a, array_b)
{
	result = [];
    for (i = 0; i < array_a.size; i++)
        result[array_a[i]] = array_b[i];
    return result;
}

/*
///DocStringBegin
detail: array_unique(<Array>: array): array
summary: Removes duplicate values from the array by returning a new array containing only unique elements in the order of their first occurrence.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_union(<Array>: array_a, <Array>: array_b): array
summary: Combines two arrays and returns an array containing only unique elements from both, preserving their order of first occurrence.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_intersection(<Array>: array_a, <Array>: array_b): array
summary: Returns an array containing only the elements that are present in both input arrays, preserving the order of first occurrence.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_difference(<Array>: array_a, <Array>: array_b): array
summary: Returns an array of elements that are in the first array but not in the second array, preserving the order of first occurrence.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_first(<Array>: array, <Function>: func, <Any>: arg1, <Any>: arg2, <Any>: arg3, <Any>: arg4, <Any>: arg5): any
summary: Returns the first element in the array that satisfies the condition defined by func when applied with up to five additional arguments. If no such element is found, returns undefined.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_index(<Array>: array, <Function>: func, <Any>: arg1, <Any>: arg2, <Any>: arg3, <Any>: arg4, <Any>: arg5): int
summary: Returns the index of the first element in the array that satisfies the condition defined by func when applied with up to five additional arguments. If no such element is found, returns undefined.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_any(<Array>: array, <Function>: func, <Any>: arg1, <Any>: arg2, <Any>: arg3, <Any>: arg4, <Any>: arg5): bool
summary: Returns true if any element in the array satisfies the condition defined by func when applied with up to five additional arguments. Otherwise, returns false.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_all(<Array>: array, <Function>: func, <Any>: arg1, <Any>: arg2, <Any>: arg3, <Any>: arg4, <Any>: arg5): bool
summary: Returns true if all elements in the array satisfy the condition defined by func when applied with up to five additional arguments. Otherwise, returns false.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_filter(<Array>: array, <Function>: func, <Any>: arg1, <Any>: arg2, <Any>: arg3, <Any>: arg4, <Any>: arg5): array
summary: Returns a new array containing only the elements that satisfy the condition defined by func when applied with up to five additional arguments.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_map(<Array>: array, <Function>: func, <Any>: arg1, <Any>: arg2, <Any>: arg3, <Any>: arg4, <Any>: arg5): array
summary: Applies func to each element in the array, with up to five additional arguments, and returns a new array containing the results.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_reduce(<Array>: array, <Any>: initial_value, <Function>: func, <Any>: arg1, <Any>: arg2, <Any>: arg3, <Any>: arg4, <Any>: arg5): any
summary: Reduces the array to a single value by applying func to each element, starting with initial_value and using up to five additional arguments. Returns the final reduced value.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_arange(<int>: start, <int>: end): array
summary: Generates an array of integers from start (inclusive) to end (exclusive), with each integer incremented by 1.
///DocStringEnd
*/
array_arange(start, end)
{
	result = [];
	for(i = start; i < end; i++)
		result[result.size] = i;
	return result;
}

/*
///DocStringBegin
detail: array_slice(<Array>: array, <int>: start, <int>: end, <int>: step): array
summary: Returns a new array containing elements from start to end (exclusive) with the specified step. Handles positive and negative steps and default values for start, end, and step.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_from_dvar(<Dvar>: dvar, <String>: split): array
summary: Converts a dynamic variable dvar to an array by splitting its value using the specified split delimiter. Returns an array with the split values or a single-element array if the value doesn't contain the delimiter.
///DocStringEnd
*/
array_from_dvar(dvar, split)
{
	if (!isDefined(split)) split = " ";	
	result = getDvar(dvar);
	
	if (result == "") return [];	
	if (result.size > 2 && isSubStr(result, split)) return strTok(result, split);
	else return [result];
}

/*
///DocStringBegin
detail: array_to_string(<Array>: array): string
summary: Converts the array into a string representation where elements are joined by a comma and enclosed in square brackets.
///DocStringEnd
*/
array_to_string(array)
{
    return "[" + scripts\lethalbeats\string::string_join(", ", array) + "]";
}

/*
///DocStringBegin
detail: array_print(<Array>: array): void
summary: Prints the array as a string representation where elements are joined by a comma and enclosed in square brackets.
///DocStringEnd
*/
array_print(array)
{
    print("[" + scripts\lethalbeats\string::string_join(", ", array) + "]");
}

/*
///DocStringBegin
detail: array_contains(<Array>: array, <Any>: item): bool
summary: Checks if the array contains the specified item. Returns true if the item is found, otherwise returns false.
///DocStringEnd
*/
array_contains(array, item)
{
	for(i = 0; i < array.size; i++)
		if (array[i] == item)
			return true;
    return false;
}

/*
///DocStringBegin
detail: array_contains_array(<Array>: array_a, <Array>: array_b): bool
summary: Checks if all elements of array_b are present in array_a. Returns true if array_a contains every element of array_b, otherwise returns false.
///DocStringEnd
*/
array_contains_array(array_a, array_b)
{
    return array_intersection(array_a, array_b).size == array_b.size;
}

/*
///DocStringBegin
detail: array_contains_key(<Array>: array, <Any>: key): bool
summary: Checks if the array contains the specified key as an index. Returns true if the key exists, otherwise returns false.
///DocStringEnd
*/
array_contains_key(array, key)
{
	return isDefined(array[key]);
}

/*
///DocStringBegin
detail: array_random_int_unique(<int>: size, <int>: min, <int>: max): array
summary: Generates an array of unique random integers of length size, where each integer is between min and max (inclusive). If duplicates are detected, it regenerates the value until uniqueness is ensured.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_append(<Array>: array, <Any>: value): array
summary: Appends the specified value to the end of the array and returns the updated array.
///DocStringEnd
*/
array_append(array, value)
{
	array[array.size] = value;
	return array;
}

/*
///DocStringBegin
detail: array_insert(<Array>: array, <int>: index, <Any>: value): array
summary: Inserts the specified value at the given index in the array and returns the new array with the value inserted.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_remove(<Array>: array, <Any>: value): array
summary: Returns an array by removing all occurrences of the specified value from the original array. Returns the updated array.
///DocStringEnd
*/
array_remove(array, value)
{
	result = [];
	foreach(i in array)
		if (i != value)
			result[result.size] = i;
	return result;
}

/*
///DocStringBegin
detail: array_remove_index(<Array>: array, <int>: index): array
summary: Returns an array by removing the element at the specified index from the original array. Returns the updated array.
///DocStringEnd
*/
array_remove_index(array, index)
{
	result = [];
	for (i = 0; i < 0; i++)
		if (i != index)
			result[result.size] = array[i];
	return result;
}

/*
///DocStringBegin
detail: array_remove_key(<Array>: array, <Any>: key): array
summary: Returns an array by removing the element with the specified key from the original array. Returns the updated array. If the key does not exist, returns the original array.
///DocStringEnd
*/
array_remove_key(array, key)
{
	if (!isDefined(array[key])) return array;

	result = [];
	keys = getArrayKeys(array);
	for (i = 0; i < keys.size; i++)
		if (keys[i] != key) result[keys[i]] = array[keys[i]];
	return result;
}

/*
///DocStringBegin
detail: array_get_keys(<Array>: array): array
summary: Returns an array of all keys from the given array.
///DocStringEnd
*/
array_get_keys(array)
{
	return getArrayKeys(array);	
}

/*
///DocStringBegin
detail: array_get_values(<Array>: array): array
summary: Returns an array of all values from the given array, preserving the order of the keys.
///DocStringEnd
*/
array_get_values(array)
{
	result = [];
	keys = getArrayKeys(array);
	for (i = 0; i < keys.size; i++)
		result[result.size] = array[keys[i]];
	return result;
}

/*
///DocStringBegin
detail: array_alphabetize(<Array>: array): array
summary: Sorts the array of strings in alphabetical order using a selection sort algorithm. Returns the sorted array. Preserves the order of elements if they are equal.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_remove_undefined(<Array>: array): array
summary: Returns an array by removing all undefined values from the original array. Returns the updated array.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_reverse(<Array>: array): array
summary: Returns a new array with the elements of the original array in reverse order.
///DocStringEnd
*/
array_reverse(array)
{
	result = [];
	for (i = array.size - 1; i >= 0; i--)
		result[result.size] = array[i];
	return result;
}

/*
///DocStringBegin
detail: array_random_item(<Array>: array): any
summary: Returns a random item from the array. If the array is empty, returns undefined.
///DocStringEnd
*/
array_random_item(array)
{
	result = [];
	foreach (index, value in array)
		result[result.size] = value;

	if (!result.size) return undefined;	
	return result[randomint(result.size)];
}

/*
///DocStringBegin
detail: array_randomize(<Array>: array): array
summary: Shuffles the elements of the array in place using the Fisher-Yates algorithm and returns the shuffled array.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_sort(<Array>: array, <bool>: ascending): array
summary: Sorts the elements of the array in-place. If ascending is true, sorts in ascending order; otherwise, sorts in descending order. Returns the sorted array.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_merge_sort(<Array>: array): array
summary: Sorts the array using the merge sort algorithm. Recursively divides the array into halves, sorts each half, and then merges the sorted halves. Returns the sorted array.
///DocStringEnd
*/
array_merge_sort(array)
{
    if (array.size <= 1) return array;
    mid = int(array.size / 2);
    left = array_merge_sort(array_slice(array, 0, mid));
    right = array_merge_sort(array_slice(array, mid, array.size));
    return array_merge(left, right);
}

/*
///DocStringBegin
detail: array_merge(<Array>: left, <Array>: right): array
summary: Merges two sorted arrays, left and right, into a single sorted array. Returns the merged sorted array.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_quick_sort(<Array>: array): array
summary: Sorts the array using the quicksort algorithm. It recursively divides the array into smaller sub-arrays around a pivot and combines the sorted results.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_index_swap(<Array>: array, <Integer>: index1, <Integer>: index2): array
summary: Swaps the elements at the specified indices in the array and returns the modified array.
///DocStringEnd
*/
array_index_swap(array, index1, index2) 
{
	temp = array[index1];          
	array[index1] = array[index2];     
	array[index2] = temp;   
	return array;         
}

/*
///DocStringBegin
detail: array_binary_search(<Array>: array, <Any>: target): int
summary: Performs a binary search on a sorted array to find the index of the target value. Returns the index if found, otherwise returns undefined.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_chunk(<Array>: array, <Integer>: size): array
summary: Splits the array into chunks of the specified size and returns an array of these chunks.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_flatten(<Array>: array): array
summary: Recursively flattens a multi-dimensional array into a single-dimensional array.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_min(<Array>: array): any
summary: Returns the minimum value from the array.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_max(<Array>: array): any
summary: Returns the maximum value from the array.
///DocStringEnd
*/
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

/*
///DocStringBegin
detail: array_is_blank(<Array>: array): bool
summary: Checks if the array is either undefined or empty. Returns true if it is blank, otherwise returns false.
///DocStringEnd
*/
array_is_blank(array) 
{ 
	return !isDefined(array) || array.size == 0; 
}

/*
///DocStringBegin
detail: filter_equal(<Any>: i, <Any>: arg1): bool
summary: Compares a value i to arg1 and returns true if they are equal, otherwise returns false.
///DocStringEnd
*/
filter_equal(i, arg1)
{ 
	return i == arg1; 
}

/*
///DocStringBegin
detail: filter_not_equal(<Any>: i, <Any>: arg1): bool
summary: Compares a value i to arg1 and returns true if they are not equal, otherwise returns false.
///DocStringEnd
*/
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
