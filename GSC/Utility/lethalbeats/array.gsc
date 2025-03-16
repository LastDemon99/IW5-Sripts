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

array_last(array)
{
	return array[array.size - 1];
}

/*
///DocStringBegin
detail: array_range(start: <Int>, end: <Int>): <Any[]>
summary: Generates an array of integers from start `(inclusive)` to end `(exclusive)`. If start is greater than end, it generates a reverse sequence.
///DocStringEnd
*/
array_range(start, end, float)
{
    result = [];
    if (start < end) 
    {
        for(i = start; i < end; i++)
            result[result.size] = i;
		return result;
    }    
	for(i = start; i > end; i--)
		result[result.size] = i;  
    return result;
}

/*
///DocStringBegin
detail: array_random_range(min: <Int>, max: <Int>, size?: <Int> = 1, unique?: <Bool> = false, floats?: <Bool> = false): <Int> | <Int[]> | <Float[]>
summary: Generates an of random numbers between `min` and `max` `(inclusive)`. If `unique` is true, it guarantees no duplicates. If `floats` is true the range will include floats values.
///DocStringEnd
*/
array_random_range(min, max, size, unique, floats)
{
	if (!isDefined(size)) size = 1;
	if (!isDefined(unique)) unique = false;
	if (!isDefined(floats)) floats = false;
	
    result = [];
    for (i = 0; i < size; i++)
    {
        random = floats ? randomFloatRange(min, max) : randomIntRange(min, max);
        if (unique)
        {
            for (j = i; j >= 0; j--)
            {
                if (isDefined(result[j]) && result[j] == random)
                {
                    random = floats ? randomFloatRange(min, max) : randomIntRange(min, max);
                    j = i;
                }
            }
        }
        result[i] = random;
    }

	if (result.size == 1) return result[0];
    return result;
}

/*
///DocStringBegin
detail: array_repeat(value: <Any>, index_count: <Int>): <Any[]>
summary: Returns an array where the given value is repeated a specified number of times.
///DocStringEnd
*/
array_repeat(value, index_count)
{
	result = [];
	for(i = 0; i < index_count; i++)
		result[i] = value;
    return result;
}

/*
///DocStringBegin
detail: array_zeros(index_count: <Int>): <Vector>
summary: Returns a array with all values set to zero.
///DocStringEnd
*/
array_zeros(index_count)
{
	return array_repeat(0, index_count);
}

/*
///DocStringBegin
detail: array_ones(indexes: <Int>): <Any[]>
summary: Returns a array with all values set to one.
///DocStringEnd
*/
array_ones(index_count)
{
    return array_repeat(1, index_count);
}

/*
///DocStringBegin
detail: array_combine(array_a: <Any[]>, array_b: <Any[]>, array_c?: <Any[]>, array_d?: <Any[]>): <Any[]>
summary: Combines arrays optionally up to 4 and returns the result. This function doesn't care if it produces duplicates.
///DocStringEnd
*/
array_combine(array_a, array_b, array_c, array_d)
{
	result = [];
	
	for (i = 0; i < array_a.size; i++)
		result[i] = array_a[i];
	size = result.size;
	for (i = 0; i < array_b.size; i++)
		result[size + i] = array_b[i];

	if (isDefined(array_c))
	{
		size = result.size;
		for (i = 0; i < array_c.size; i++)
			result[size + i] = array_c[i];
	}

	if (isDefined(array_d))
	{
		size = result.size;
		for (i = 0; i < array_d.size; i++)
			result[size + i] = array_d[i];
	}

	return result;
}

/*
///DocStringBegin
detail: array_unique(array: <Any[]>): <Any[]>
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
detail: array_union(array_a: <Any[]>, array_b: <Any[]>): <Any[]>
summary: Combines two arrays and returns an array containing only unique elements from both, preserving their order of first occurrence.
///DocStringEnd
*/
array_union(array_a, array_b)
{
	return array_unique(array_combine(array_a, array_b));
}

/*
///DocStringBegin
detail: array_intersection(array_a: <Any[]>, array_b: <Any[]>): <Any[]>
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

	return array_unique(result);
}

/*
///DocStringBegin
detail: array_difference(array_a: <Any[]>, array_b: <Any[]>): <Any[]>
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
detail: array_slice(array: <Any[]>, start: <Int>, end: <Int>, step: <Int>): <Any[]>
summary: Returns a new array containing elements from start `(inclusive)` to end `(exclusive)` with the specified step. Handles positive and negative steps and default values for start, end, and step.
///DocStringEnd
*/
array_slice(array, start, end, step)
{
    result = [];	
    if (!isDefined(step) || step == 0) step = 1;

    if (step > 0)
    {
        if (!isDefined(start)) start = 0;
        if (!isDefined(end)) end = array.size;
        
        for (i = start; i < end && i < array.size; i += step)
            result[result.size] = array[i];
    }
    else
    {
        if (!isDefined(start) || start >= array.size) start = array.size - 1;
        if (!isDefined(end)) end = -1;
        
        for (i = start; i >= end && i >= 0; i += step)
            result[result.size] = array[i];
    }
    return result;
}

/*
///DocStringBegin
detail: array_map(array: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Any[]>
summary: Applies func to each element in the array, with up to five additional arguments, and returns a new array containing the results.
///DocStringEnd
*/
array_map(array, func, arg1, arg2, arg3, arg4, arg5)
{
	args = [arg1, arg2, arg3, arg4, arg5];
	format = _args_format(args);
	args = format[0];
	i_index = format[1];
	result = [];
	
	for(i = 0; i < array.size; i++)
	{
		args[i_index] = array[i];
		switch(args.size)
		{
			case 1: result[result.size] = [[func]](args[0]); break;
			case 2: result[result.size] = [[func]](args[0], args[1]); break;
			case 3: result[result.size] = [[func]](args[0], args[1], args[2]); break;
			case 4: result[result.size] = [[func]](args[0], args[1], args[2], args[3]); break;
			case 5: result[result.size] = [[func]](args[0], args[1], args[2], args[3], args[4]); break;
			case 6: result[result.size] = [[func]](args[0], args[1], args[2], args[3], args[4], args[5]); break;
		}
	}
	return result;
}

/*
///DocStringBegin
detail: array_reduce(array: <Any[]>, initial_value: <Any>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Any>
summary: Reduces the array to a single value by applying func to each element, starting with initial_value and using up to five additional arguments. Returns the final reduced value.
///DocStringEnd
*/
array_reduce(array, initial_value, func, arg1, arg2, arg3, arg4, arg5)
{
	args = [arg1, arg2, arg3, arg4, arg5];
	format = _args_format(args);
	args = format[0];
	i_index = format[1];
	result = initial_value;
	
	for(i = 0; i < array.size; i++)
	{
		args[i_index] = array[i];
		switch(args.size)
		{
			case 1: result = [[func]](result, args[0]); break;
			case 2: result = [[func]](result, args[0], args[1]); break;
			case 3: result = [[func]](result, args[0], args[1], args[2]); break;
			case 4: result = [[func]](result, args[0], args[1], args[2], args[3]); break;
			case 5: result = [[func]](result, args[0], args[1], args[2], args[3], args[4]); break;
			case 6: result = [[func]](result, args[0], args[1], args[2], args[3], args[4], args[5]); break;
		}
	}
	return result;
}

/*
///DocStringBegin
detail: array_zip(array_a: <Any[]>, array_b: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Any[]>
summary: Applies func to each elements in two arrays, with up to five additional arguments, and returns a new array containing the results.
///DocStringEnd
*/
array_zip(array_a, array_b, func, arg1, arg2, arg3, arg4, arg5)
{
	if (array_a.size != array_b.size) return [];
	args = [arg1, arg2, arg3, arg4, arg5];
	format = _args_zip_format(args);
	args = format[0];
	x_index = format[1];
	y_index = format[2];
	result = [];
	
	for(i = 0; i < array_a.size; i++)
	{
		args[x_index] = array_a[i];
		args[y_index] = array_b[i];
		switch(args.size)
		{
			case 2: result[result.size] = [[func]](args[0], args[1]); break;
			case 3: result[result.size] = [[func]](args[0], args[1], args[2]); break;
			case 4: result[result.size] = [[func]](args[0], args[1], args[2], args[3]); break;
			case 5: result[result.size] = [[func]](args[0], args[1], args[2], args[3], args[4]); break;
			case 6: result[result.size] = [[func]](args[0], args[1], args[2], args[3], args[4], args[5]); break;
		}
	}
	return result;
}

/*
///DocStringBegin
detail: array_zip_reduce(array_a: <Any[]>, array_b: <Any[]>, initial_value: <Any>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Any>
summary: Reduces two arrays to a single value by applying func to each elements, starting with initial_value and using up to five additional arguments. Returns the final reduced value.
///DocStringEnd
*/
array_zip_reduce(array_a, array_b, initial_value, func, arg1, arg2, arg3, arg4, arg5)
{
	if (array_a.size != array_b.size) return initial_value;
	args = [arg1, arg2, arg3, arg4, arg5];
	format = _args_zip_format(args);
	args = format[0];
	x_index = format[1];
	y_index = format[2];
	result = initial_value;
	
	for(i = 0; i < array_a.size; i++)
	{
		args[x_index] = array_a[i];
		args[y_index] = array_b[i];
		switch(args.size)
		{
			case 2: result = [[func]](result, args[0], args[1]); break;
			case 3: result = [[func]](result, args[0], args[1], args[2]); break;
			case 4: result = [[func]](result, args[0], args[1], args[2], args[3]); break;
			case 5: result = [[func]](result, args[0], args[1], args[2], args[3], args[4]); break;
			case 6: result = [[func]](result, args[0], args[1], args[2], args[3], args[4], args[5]); break;
		}
	}
	return result;
}

/*
///DocStringBegin
detail: array_call(array: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Void>
summary: Applies foreach to an array and call function to being able to handle the elements and additional arguments.
///DocStringEnd
*/
array_call(array, func, arg1, arg2, arg3, arg4, arg5)
{	
	args = [arg1, arg2, arg3, arg4, arg5];
	format = _args_format(args);
	args = format[0];
	i_index = format[1];
	
	for(i = 0; i < array.size; i++)
	{
		args[i_index] = array[i];
		switch(args.size)
		{
			case 1: [[func]](args[0]);
			case 2: [[func]](args[0], args[1]);
			case 3: [[func]](args[0], args[1], args[2]);
			case 4: [[func]](args[0], args[1], args[2], args[3]);
			case 5: [[func]](args[0], args[1], args[2], args[3], args[4]);
			case 6: [[func]](args[0], args[1], args[2], args[3], args[4], args[5]);
		}
	}
}

/*
///DocStringBegin
detail: array_thread(array: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Void>
summary: Applies foreach to an array and call function to being able to handle the elements and additional arguments in thread, preventing code interruption.
///DocStringEnd
*/
array_thread(array, func, arg1, arg2, arg3, arg4, arg5)
{	
	args = [arg1, arg2, arg3, arg4, arg5];
	format = _args_format(args);
	args = format[0];
	i_index = format[1];
	
	for(i = 0; i < array.size; i++)
	{
		args[i_index] = array[i];
		switch(args.size)
		{
			case 1: thread [[func]](args[0]);
			case 2: thread [[func]](args[0], args[1]);
			case 3: thread [[func]](args[0], args[1], args[2]);
			case 4: thread [[func]](args[0], args[1], args[2], args[3]);
			case 5: thread [[func]](args[0], args[1], args[2], args[3], args[4]);
			case 6: thread [[func]](args[0], args[1], args[2], args[3], args[4], args[5]);
		}
	}
}

/*
///DocStringBegin
detail: array_ent_call(entities: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Void>
summary: Applies foreach to an entities and call associated function to being able to handle the entity and additional arguments.
///DocStringEnd
*/
array_ent_call(entities, func, arg1, arg2, arg3, arg4, arg5)
{
	args = _args_ent_format([arg1, arg2, arg3, arg4, arg5]);
	foreach(ent in entities)
	{
		switch(args.size)
		{
			case 0: ent [[func]](); break;
			case 1: ent [[func]](args[0]); break;
			case 2: ent [[func]](args[0], args[1]); break;
			case 3: ent [[func]](args[0], args[1], args[2]); break;
			case 4: ent [[func]](args[0], args[1], args[2], args[3]); break;
			case 5: ent [[func]](args[0], args[1], args[2], args[3], args[4]); break;
		}
	}
}

/*
///DocStringBegin
detail: array_ent_thread(entities: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Void>
summary: Applies foreach to an entities and call associated function to being able to handle the entity and additional arguments in thread, preventing code interruption.
///DocStringEnd
*/
array_ent_thread(entities, func, arg1, arg2, arg3, arg4, arg5)
{	
	args = _args_ent_format([arg1, arg2, arg3, arg4, arg5]);
	foreach(ent in entities)
	{
		switch(args.size)
		{
			case 0: ent thread [[func]](); break;
			case 1: ent thread [[func]](args[0]); break;
			case 2: ent thread [[func]](args[0], args[1]); break;
			case 3: ent thread [[func]](args[0], args[1], args[2]); break;
			case 4: ent thread [[func]](args[0], args[1], args[2], args[3]); break;
			case 5: ent thread [[func]](args[0], args[1], args[2], args[3], args[4]); break;
		}
	}
}

/*
///DocStringBegin
detail: array_find(array: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Any> | <Undefined>
summary: Returns the first element in the array that satisfies the condition defined by func when applied with up to five additional arguments. If no such element is found, returns undefined.
///DocStringEnd
*/
array_find(array, func, arg1, arg2, arg3, arg4, arg5)
{
	args = [arg1, arg2, arg3, arg4, arg5];
	format = _args_format(args);
	args = format[0];
	i_index = format[1];
	
	for(i = 0; i < array.size; i++)
	{
		args[i_index] = array[i];
		switch(args.size)
		{
			case 0: if ([[func]](array[i])) return array[i]; break;
			case 1: if ([[func]](args[0])) return array[i]; break;
			case 2: if ([[func]](args[0], args[1])) return array[i]; break;
			case 3: if ([[func]](args[0], args[1], args[2])) return array[i]; break;
			case 4: if ([[func]](args[0], args[1], args[2], args[3])) return array[i]; break;
			case 5: if ([[func]](args[0], args[1], args[2], args[3], args[4])) return array[i]; break;
			case 6: if ([[func]](args[0], args[1], args[2], args[3], args[4], args[5])) return array[i]; break;
		}
	}
	return undefined;
}

/*
///DocStringBegin
detail: array_find_ent(entities: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Any> | <Undefined>
summary: Returns the first entity in the array that satisfies the condition defined by func when applied with up to five additional arguments. If no such element is found, returns undefined.
///DocStringEnd
*/
array_find_ent(entities, func, arg1, arg2, arg3, arg4, arg5)
{
	args = _args_ent_format([arg1, arg2, arg3, arg4, arg5]);
	foreach(ent in entities)
	{
		switch(args.size)
		{
			case 0: if (ent [[func]]()) return ent; break;
			case 1: if (ent [[func]](args[0])) return ent; break;
			case 2: if (ent [[func]](args[0], args[1])) return ent; break;
			case 3: if (ent [[func]](args[0], args[1], args[2])) return ent; break;
			case 4: if (ent [[func]](args[0], args[1], args[2], args[3])) return ent; break;
			case 5: if (ent [[func]](args[0], args[1], args[2], args[3], args[4])) return ent; break;
		}
	}
	return undefined;
}

/*
///DocStringBegin
detail: array_index(array: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Int?>
summary: Returns the index of the first element in the array that satisfies the condition defined by func when applied with up to five additional arguments. If no such element is found, returns undefined.
///DocStringEnd
*/
array_index(array, func, arg1, arg2, arg3, arg4, arg5)
{
	args = [arg1, arg2, arg3, arg4, arg5];
	format = _args_format(args);
	args = format[0];
	i_index = format[1];

	for(i = 0; i < array.size; i++)
	{
		args[i_index] = array[i];
		switch(args.size)
		{
			case 1: if ([[func]](args[0])) return i; break;
			case 2: if ([[func]](args[0], args[1])) return i; break;
			case 3: if ([[func]](args[0], args[1], args[2])) return i; break;
			case 4: if ([[func]](args[0], args[1], args[2], args[3])) return i; break;
			case 5: if ([[func]](args[0], args[1], args[2], args[3], args[4])) return i; break;
			case 6: if ([[func]](args[0], args[1], args[2], args[3], args[4], args[5])) return i; break;
		}
	}
	return undefined;
}

/*
///DocStringBegin
detail: array_index_ent(entities: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Int?>
summary: Returns the index of the first entity in the array that satisfies the condition defined by func when applied with up to five additional arguments. If no such element is found, returns undefined.
///DocStringEnd
*/
array_index_ent(entities, func, arg1, arg2, arg3, arg4, arg5)
{
	args = _args_ent_format([arg1, arg2, arg3, arg4, arg5]);
	for(i = 0; i < entities.size; i++)
	{
		switch(args.size)
		{
			case 0: if (entities[i] [[func]]()) return i; break;
			case 1: if (entities[i] [[func]](args[0])) return i; break;
			case 2: if (entities[i] [[func]](args[0], args[1])) return i; break;
			case 3: if (entities[i] [[func]](args[0], args[1], args[2])) return i; break;
			case 4: if (entities[i] [[func]](args[0], args[1], args[2], args[3])) return i; break;
			case 5: if (entities[i] [[func]](args[0], args[1], args[2], args[3], args[4])) return i; break;
		}
	}
	return undefined;
}

/*
///DocStringBegin
detail: array_any(array: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Bool>
summary: Checks if any element in the array satisfies the condition defined by func when applied with up to five additional arguments. Returns true if at least one element satisfies the condition, otherwise returns false.
///DocStringEnd
*/
array_any(array, func, arg1, arg2, arg3, arg4, arg5)
{
	args = [arg1, arg2, arg3, arg4, arg5];
	format = _args_format(args);
	args = format[0];
	i_index = format[1];

	for(i = 0; i < array.size; i++)
	{
		args[i_index] = array[i];
		switch(args.size)
		{
			case 1: if ([[func]](args[0])) return true; break;
			case 2: if ([[func]](args[0], args[1])) return true; break;
			case 3: if ([[func]](args[0], args[1], args[2])) return true; break;
			case 4: if ([[func]](args[0], args[1], args[2], args[3])) return true; break;
			case 5: if ([[func]](args[0], args[1], args[2], args[3], args[4])) return true; break;
			case 6: if ([[func]](args[0], args[1], args[2], args[3], args[4], args[5])) return true; break;
		}
	}
	return false;
}

/*
///DocStringBegin
detail: array_any_ent(entities: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Bool>
summary: Checks if any entity in the array satisfies the condition defined by func when applied with up to five additional arguments. Returns true if at least one element satisfies the condition, otherwise returns false.
///DocStringEnd
*/
array_any_ent(entities, func, arg1, arg2, arg3, arg4, arg5)
{
	args = _args_ent_format([arg1, arg2, arg3, arg4, arg5]);
	foreach(ent in entities)
	{
		switch(args.size)
		{
			case 0: if (ent [[func]]()) return true; break;
			case 1: if (ent [[func]](args[0])) return true; break;
			case 2: if (ent [[func]](args[0], args[1])) return true; break;
			case 3: if (ent [[func]](args[0], args[1], args[2])) return true; break;
			case 4: if (ent [[func]](args[0], args[1], args[2], args[3])) return true; break;
			case 5: if (ent [[func]](args[0], args[1], args[2], args[3], args[4])) return true; break;
		}
	}
	return false;
}

/*
///DocStringBegin
detail: array_all(array: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Bool>
summary: Checks if all elements in the array satisfy the condition defined by func when applied with up to five additional arguments. Returns true if all elements satisfy the condition, otherwise returns false.
///DocStringEnd
*/
array_all(array, func, arg1, arg2, arg3, arg4, arg5)
{
	args = [arg1, arg2, arg3, arg4, arg5];
	format = _args_format(args);
	args = format[0];
	i_index = format[1];
	
	for(i = 0; i < array.size; i++)
	{
		args[i_index] = array[i];
		switch(args.size)
		{
			case 1: if (![[func]](args[0])) return false; break;
			case 2: if (![[func]](args[0], args[1])) return false; break;
			case 3: if (![[func]](args[0], args[1], args[2])) return false; break;
			case 4: if (![[func]](args[0], args[1], args[2], args[3])) return false; break;
			case 5: if (![[func]](args[0], args[1], args[2], args[3], args[4])) return false; break;
			case 6: if (![[func]](args[0], args[1], args[2], args[3], args[4], args[5])) return false; break;
		}
	}
	return true;
}

/*
///DocStringBegin
detail: array_all_ent(entities: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Bool>
summary: Checks if all entities in the array satisfy the condition defined by func when applied with up to five additional arguments. Returns true if all elements satisfy the condition, otherwise returns false.
///DocStringEnd
*/
array_all_ent(entities, func, arg1, arg2, arg3, arg4, arg5)
{
	args = _args_ent_format([arg1, arg2, arg3, arg4, arg5]);
	foreach(ent in entities)
	{
		switch(args.size)
		{
			case 0: if (ent [[func]]()) return false; break;
			case 1: if (ent [[func]](args[0])) return false; break;
			case 2: if (ent [[func]](args[0], args[1])) return false; break;
			case 3: if (ent [[func]](args[0], args[1], args[2])) return false; break;
			case 4: if (ent [[func]](args[0], args[1], args[2], args[3])) return false; break;
			case 5: if (ent [[func]](args[0], args[1], args[2], args[3], args[4])) return false; break;
		}
	}
	return true;
}

/*
///DocStringBegin
detail: array_filter(array: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Any[]>
summary: Returns a new array containing only the elements that satisfy the condition defined by func when applied with up to five additional arguments.
///DocStringEnd
*/
array_filter(array, func, arg1, arg2, arg3, arg4, arg5)
{	
	args = [arg1, arg2, arg3, arg4, arg5];
	format = _args_format(args);
	args = format[0];
	i_index = format[1];
	result = [];
	
	for(i = 0; i < array.size; i++)
	{
		args[i_index] = array[i];
		switch(args.size)
		{
			case 1: if ([[func]](args[0])) result[result.size] = array[i]; break;
			case 2: if ([[func]](args[0], args[1])) result[result.size] = array[i]; break;
			case 3: if ([[func]](args[0], args[1], args[2])) result[result.size] = array[i]; break;
			case 4: if ([[func]](args[0], args[1], args[2], args[3])) result[result.size] = array[i]; break;
			case 5: if ([[func]](args[0], args[1], args[2], args[3], args[4])) result[result.size] = array[i]; break;
			case 6: if ([[func]](args[0], args[1], args[2], args[3], args[4], args[5])) result[result.size] = array[i]; break;
		}
	}
	return result;
}

/*
///DocStringBegin
detail: array_filter_ent(entities: <Any[]>, func: <Function>, arg1?: <Any>, arg2?: <Any>, arg3?: <Any>, arg4?: <Any>, arg5?: <Any>): <Any[]>
summary: Returns a new array containing only the entities that satisfy the condition defined by func when applied with up to five additional arguments.
///DocStringEnd
*/
array_filter_ent(entities, func, arg1, arg2, arg3, arg4, arg5)
{
	args = _args_ent_format([arg1, arg2, arg3, arg4, arg5]);
	result = [];
	foreach(ent in entities)
	{
		switch(args.size)
		{
			case 0: if (ent [[func]]()) result[result.size] = ent; break;
			case 1: if (ent [[func]](args[0])) result[result.size] = ent; break;
			case 2: if (ent [[func]](args[0], args[1])) result[result.size] = ent; break;
			case 3: if (ent [[func]](args[0], args[1], args[2])) result[result.size] = ent; break;
			case 4: if (ent [[func]](args[0], args[1], args[2], args[3])) result[result.size] = ent; break;
			case 5: if (ent [[func]](args[0], args[1], args[2], args[3], args[4])) result[result.size] = ent; break;
		}
	}
	return result;
}

/*
///DocStringBegin
detail: array_to_dictionary(keys: <Any[]>, values: <Any[]>): <Dictionary>
summary: Converts two arrays into a dictionary where elements of the first array become keys, and elements of the second array become the corresponding values.
///DocStringEnd
*/
array_to_dictionary(keys, values)
{
	result = [];
    for (i = 0; i < keys.size; i++)
        result[keys[i]] = values[i];
    return result;
}

/*
///DocStringBegin
detail: array_get_keys(array: <Any[]>): <Any[]>
summary: Returns an array of all keys from the given array.
///DocStringEnd
*/
array_get_keys(array)
{
	return getArrayKeys(array);	
}

/*
///DocStringBegin
detail: array_get_values(array: <Any[]>): <Any[]>
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
detail: array_remove_key(array: <Any[]>, key: <Any>): <Any[]>
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
detail: array_from_dvar(dvar: <Dvar>, split: <String>): <Any[]>
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
detail: array_is_dictionary(target?: <Any[]>): <Bool>
summary: Returns true if the array is in key-value format, which differs with sorted numeric indices.
///DocStringEnd
*/
array_is_dictionary(target)
{
	keys = [];
	foreach(key, value in target)
		keys[keys.size] = key;

	keys = array_sort(keys); /* (◞ ‸ ◟ㆀ)        (¬_¬ ) (´･ω･`) why??   
	getArrayKeys([1 , 5, 7.8, "test"]) => [0, 1, 2, 3] ✔️	|	| ヽ(≧◡≦)八(o^ ^o)ノ
	test = array_to_dictionary(["test0", "test1", "test2", "test3"], [1 , 5, 7.8, "test"]);
	keys = getArrayKeys(test) => ["test0", "test1", "test2"] ✔️	|	| (o^ ^o)˚°◦([0, 1, 2, 3])
	getArrayKeys(keys) => [3, 2, 1, 0]	|	| (╯°□°）╯︵ ┻━┻???
	✧ keys = array_sort(keys); ✧ => [0, 1, 2, 3] ✔️	|	| (*TーT)人(TーT*)
	*/

	return !array_compare(keys, array_range(0, keys.size), true);
}

/*
///DocStringBegin
detail: array_print(array: <Any[]>): <Void>
summary: Prints the array as a string representation where elements are joined by a comma and enclosed in square brackets.
///DocStringEnd
*/
array_print(array)
{
	print(lethalbeats\json::json_serialize(array));
}

/*
///DocStringBegin
detail: array_count(array: <Any[]>, target: <Any>): <Int>
summary: Counts the number of occurrences of the specified target in the array. Returns the count as an integer.
///DocStringEnd
*/
array_count(array, target)
{
    count = 0;
    for(i = 0; i < array.size; i++)
        if (array[i] == target) count = count + 1;
    return count;
}

/*
///DocStringBegin
detail: array_contains(array: <Any[]>, item: <Any>): <Bool>
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
detail: array_contains_array(array_a: <Any[]>, array_b: <Any[]>): <Bool>
summary: Checks if all elements of array_b are present in array_a. Returns true if array_a contains every element of array_b, otherwise returns false.
///DocStringEnd
*/
array_contains_array(array_a, array_b)
{
	return array_intersection(array_a, array_b).size == array_b.size;
}

/*
///DocStringBegin
detail: array_contains_key(array: <Any[]>, key: <Any>): <Bool>
summary: Checks if the array contains the specified key as an index. Returns true if the key exists, otherwise returns false.
///DocStringEnd
*/
array_contains_key(array, key)
{
	return isDefined(array[key]);
}

/*
///DocStringBegin
detail: array_random(array: <Any[]>): <Any>
summary: Returns a random item from the array. If the array is empty, returns undefined.
///DocStringEnd
*/
array_random(array)
{
	newarray = [];
	foreach (index, value in array)
		newarray[newarray.size] = value;
	if (!newarray.size) return undefined;	
	return newarray[randomint(newarray.size)];
}

/*
///DocStringBegin
detail: array_random_choices(array: <Any[]>, sample_count?: <Int>, weights?: <Any[]>, unique?: <Bool>): <Any[]>
summary: Returns an array of randomly selected elements from the input array. The number of elements to sample is specified by sample_count. If weights are provided, they determine the probability of each element being selected. The unique parameter enforces no repetition in the selected elements if set to true.
///DocStringEnd
*/
array_random_choices(array, sample_count, weights, unique) 
{
    if (!array.size) return [];
	if (!isDefined(unique)) unique = false;
    if (!isdefined(weights) || weights.size != array.size) 
	{
        weights = [];
        foreach (index, value in array) weights[index] = 1;
    }

    if (!isdefined(sample_count) || sample_count <= 0) sample_count = 1;
    if (unique && sample_count > array.size) sample_count = array.size;

    total_weight = 0;
    cumulative_weights = [];
    foreach (index, weight in weights) 
	{
        total_weight += weight;
        cumulative_weights[index] = total_weight;
    }

    newarray = [];
    used_indices = [];

    for (i = 0; i < sample_count; i++) 
	{
        random_value = randomfloat(total_weight);        
        foreach (index, cumulative_weight in cumulative_weights) 
		{
            if (random_value < cumulative_weight) 
			{
                if (unique && array_contains(used_indices, index)) 
				{
                    random_value = randomfloat(total_weight);
                    continue;
                }

                newarray[newarray.size] = array[index];
                if (unique) 
				{
                    used_indices[used_indices.size] = index;
                    total_weight -= weights[index];
                    for (j = index; j < cumulative_weights.size; j++)
						cumulative_weights[j] -= weights[index];
                }
                break;
            }
        }
    }
    return newarray;
}

/*
///DocStringBegin
detail: array_append(array: <Any[]>, value: <Any>): <Any[]>
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
detail: array_insert(array: <Any[]>, index: <Int>, value: <Any>): <Any[]>
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
detail: array_remove(array: <Any[]>, value: <Any>): <Any[]>
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
detail: array_remove_index(array: <Any[]>, index: <Int>): <Any[]>
summary: Returns an array by removing the element at the specified index from the original array. Returns the updated array.
///DocStringEnd
*/
array_remove_index(array, index)
{
	result = [];
	for (i = 0; i < array.size; i++)
		if (i != index)
			result[result.size] = array[i];
	return result;
}

/*
///DocStringBegin
detail: array_pop(array: <Any[]>): <Any[]> -> [updatedArray: <Any[]>, popItem: <Any>]
summary: Removes the last element from the array and returns an array containing the updated array and the removed element.
///DocStringEnd
*/
array_pop(array)
{
	if (!array.size) return [array, undefined];
	valueIndex = array.size - 1;
	return [array_remove_index(array, valueIndex), array[valueIndex]];
}

/*
///DocStringBegin
detail: array_alphabetize(array: <String[]>): <String[]>
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
detail: array_remove_undefined(array: <Any[]>): <Any[]>
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
detail: array_reverse(array: <Any[]>): <Any[]>
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
detail: array_compare(array_a: <Any[]>, array_b: <Any[]>, strict?: <Bool> = false): <Bool>
summary: Returns true if the two arrays are equal in size and contain the same elements in the same order. Otherwise, returns false.
///DocStringEnd
*/
array_compare(array_a, array_b, strict)
{
	if (array_a.size != array_b.size) return false;
	if (!isDefined(strict)) strict = false;
	if (!strict)
	{
		unique_a = array_unique(array_a);
		unique_b = array_unique(array_b);

		if (unique_a.size != unique_b.size) return false;

		foreach(i in unique_a)
			if (!array_contains(unique_b, i)) return false;
		return true;
	}

	for (i = 0; i < array_a.size; i++)
	{
		if (!lethalbeats\utility::is_type_equal(array_a[i], array_b[i]))
			return false;

		if (isArray(array_a[i]))
        {
            if (!array_compare(array_a[i], array_b[i], true))
                return false;
        }
        else if (array_a[i] != array_b[i])
            return false;
	}
	return true;
}

/*
///DocStringBegin
detail: array_shuffle(array: <Any[]>): <Any[]>
summary: Shuffles the elements of the array in place using the Fisher-Yates algorithm and returns the shuffled array.
///DocStringEnd
*/
array_shuffle(array)
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
detail: array_sort(array: <Any[]>, ascending: <Bool>): <Any[]>
summary: Sorts the elements of the array in-place. If ascending is true, sorts in ascending order; otherwise, sorts in descending order. Returns the sorted array.
///DocStringEnd
*/
array_sort(array, ascending)
{
	if (!isDefined(ascending)) ascending = true;
	if (array_any(array, ::filter_isString))
	{
		array = array_map(array, ::map_to_string);
		return array_alphabetize(array);
	}

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
detail: array_merge_sort(array: <Any[]>): <Any[]>
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
detail: array_merge(left: <Any[]>, right: <Any[]>): <Any[]>
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
detail: array_quick_sort(array: <Any[]>): <Any[]>
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
	return array_combine(array_quick_sort(left), [pivot], array_quick_sort(right));
}

/*
///DocStringBegin
detail: array_index_swap(array: <Any[]>, index1: <Integer>, index2: <Integer>): <Any[]>
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
detail: array_binary_search(array: <Any[]>, target: <Any>): <Int>
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
detail: array_chunk(array: <Any[]>, size: <Int>): <Any[]>
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
detail: array_flatten(array: <Any[]>): <Any[]>
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
detail: array_transpose(matrix: <Any[]>): <Any[]> | undefined
summary: Transposes a given 2D array (matrix), swapping rows and columns.
///DocStringEnd
*/
array_transpose(matrix) 
{
    if (matrix.size == 0 || matrix[0].size == 0) return undefined;

    result = [];
    for (i = 0; i < matrix[0].size; i++)
	{
        result[i] = [];
        for (j = 0; j < matrix.size; j++)
			result[i][j] = matrix[j][i];
    }
    return result;
}

/*
///DocStringBegin
detail: array_min(array: <Any[]>): <Any>
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
detail: array_max(array: <Any[]>): <Any>
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

array_sum(array)
{
	return array_reduce(array, 0, lethalbeats\math::math_sum);
}

array_average(array)
{
	return array_sum(array) / array.size;
}

/*
///DocStringBegin
detail: array_is_blank(array: <Any[]>): <Bool>
summary: Checks if the array is either undefined or empty. Returns true if it is blank, otherwise returns false.
///DocStringEnd
*/
array_is_blank(array) 
{ 
	return !isDefined(array) || array.size == 0; 
}

filter_equal(i, arg1) { return i == arg1; }
filter_not_equal(i, arg1) { return i != arg1; }
filter_greater_than(i, arg1) { return i > arg1; }
filter_less_than(i, arg1) { return i < arg1; }
filter_greater_or_equal(i, arg1) { return i >= arg1; }
filter_less_or_equal(i, arg1) { return i <= arg1; }
filter_between(i, arg1, arg2) { return i >= arg1 && i <= arg2; }
filter_not_between(i, arg1, arg2) { return !filter_between(i, arg1, arg2); }
filter_is_undefined(i) { return i == undefined; }
filter_not_is_undefined(i) { return i != undefined; }
filter_isString(value) { return isString(value); } // engine funcs cannot be send as pointers, aux func required (◞ ‸ ◟ㆀ)
filter_starts_with(i, arg1, lower) 
{
	if (isDefined(lower) && lower) return lethalbeats\string::string_starts_with(toLower(i), toLower(arg1));
	return lethalbeats\string::string_starts_with(i, arg1); 
}
filter_not_starts_with(i, arg1, lower)
{
	if (isDefined(lower) && lower) return !filter_starts_with(toLower(i), toLower(arg1));
	return !filter_starts_with(i, arg1);
}
filter_ends_with(i, arg1, lower)
{
	if (isDefined(lower) && lower) return lethalbeats\string::string_ends_with(toLower(i), toLower(arg1));
	return lethalbeats\string::string_ends_with(i, arg1);
}
filter_not_ends_with(i, arg1, lower)
{
	if (isDefined(lower) && lower) return !filter_ends_with(toLower(i), toLower(arg1));
	return !filter_ends_with(i, arg1);
}

map_to_string(value) { return isString(value) ? value : value + ""; }

null() { return "{}"; }
i() { return "{i}"; }
i1() { return "{i1}"; }
i2() { return "{i2}"; }

_args_format(args)
{
	i_index = undefined;
	result = [];
	for(i = 0; i < 5; i++)
	{
		if (!isDefined(args[i])) break;
		if (isString(args[i]))
		{
			if (args[i] == null())
			{
				result[i] = undefined;
				continue;
			}
			else if (args[i] == i()) i_index = i;
		}
		result[i] = args[i];
	}

	if (!isDefined(i_index))
	{
		i_index = 0;
		result = array_insert(result, 0, i());
	}

	return [result, i_index];
}
_args_ent_format(args)
{
	result = [];
	for(i = 0; i < 5; i++)
	{
		if (!isDefined(args[i])) break;
		if (isString(args[i]))
		{
			if (args[i] == null())
			{
				result[i] = undefined;
				continue;
			}
		}
		result[i] = args[i];
	}
	return result;
}
_args_zip_format(args)
{
	x_index = undefined;
	y_index = undefined;

	result = [];
	for(i = 0; i < 5; i++)
	{
		if (!isDefined(args[i])) break;
		if (isString(args[i]))
		{
			if (args[i] == null())
			{
				result[i] = undefined;
				continue;
			}
			else if (args[i] == i1()) x_index = i;
			else if (args[i] == i2()) y_index = i;
		}
		result[i] = args[i];
	}

	if (!isDefined(x_index) && !isDefined(y_index))
	{
		x_index = 0;
		y_index = 1;
		result = array_insert(result, 0, i1());
		result = array_insert(result, 1, i2());
	}

	return [result, x_index, y_index];
}
