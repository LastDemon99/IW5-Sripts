/*
///DocStringBegin
detail: json_serialize(value: <Any>): <String>
summary: Serializes any given value (primitive, array or associative array) into a JSON-formatted string.
///DocStringEnd
*/
json_serialize(value)
{
    if (!isDefined(value))
        return "null";

    if (isArray(value))
    {
        if (lethalbeats\array::array_is_dictionary(value))
        {
            keys = getArrayKeys(value);
            result = [];
            for (i = 0; i < keys.size; i++)
            {
                key = keys[i];
                json_key = "\"" + _json_escape_string(key) + "\"";
                json_val = json_serialize(value[key]);
                result[result.size] = json_key + ": " + json_val;
            }
            return "{" + lethalbeats\string::string_join(", ", result) + "}";
        }
        else
        {
            result = [];
            for (i = 0; i < value.size; i++)
            {
                result[result.size] = json_serialize(value[i]);
            }
            return "[" + lethalbeats\string::string_join(", ", result) + "]";
        }
    }
    
    if (isString(value))
        return "\"" + _json_escape_string(value) + "\"";
    
    return value;
}

/*
///DocStringBegin
detail: json_parse(json_string: <String>): <Any>
summary: Parses a JSON-formatted string and returns the corresponding array or primitive value.
*/
json_parse(json_string)
{
    level.global_json = json_string;
    level.json_index = 0;
    return _json_parse_value();
}

_json_escape_string(str)
{
    result = "";
    i = 0;
    while (i < str.size)
    {
        ch = str[i];
        if(ch == "\\")
        {
            if(i + 1 < str.size)
            {
                nextChar = str[i + 1];
                result += nextChar;
                i += 2;
                continue;
            }
            else
            {
                i++;
                continue;
            }
        }
        else if(ch == "\f") result += "f";
        else if(ch == "\b") result += "b";
        else if(ch == "\n") result += "n";
        else if(ch == "\r") result += "r";
        else if(ch == "\t") result += "t";
        else if(ch == "\"") result += "\\\"";
        else result += ch;
        i++;
    }
    return result;
}

_json_skip_whitespace()
{
    while (level.json_index < level.global_json.size && (level.global_json[level.json_index] == " " || level.global_json[level.json_index] == "\n" || level.global_json[level.json_index] == "\r" || level.global_json[level.json_index] == "\t"))
        level.json_index++;
}

_json_parse_value()
{
    _json_skip_whitespace();
    ch = level.global_json[level.json_index];
    if(ch == "{") return _json_parse_object();
    else if(ch == "[") return _json_parse_array();
    else if(ch == "\"") return _json_parse_string();
    else if(ch == "-" || _is_digit(ch)) return _json_parse_number();
    else if(ch == "(") return _json_parse_vector();
    else return _json_parse_literal();
}

_json_parse_object()
{
    level.json_index++;
    _json_skip_whitespace();
    obj = [];

    if(level.global_json[level.json_index] == "}")
    {
        level.json_index++;
        return obj;
    }

    while (true)
    {
        _json_skip_whitespace();
        key = _json_parse_string();
        _json_skip_whitespace();

        if(level.global_json[level.json_index] != ":")
        return undefined;
        
        level.json_index++;
        _json_skip_whitespace();
        value = _json_parse_value();
        obj[key] = value;
        _json_skip_whitespace();

        if(level.global_json[level.json_index] == "}")
        {
            level.json_index++;
            break;
        }
        else if(level.global_json[level.json_index] == ",")
        level.json_index++;
        else break;
    }
    return obj;
}

_json_parse_array()
{
    level.json_index++;
    _json_skip_whitespace();
    arr = [];

    if(level.global_json[level.json_index] == "]")
    {
        level.json_index++;
        return arr;
    }

    while (true)
    {
        _json_skip_whitespace();
        element = _json_parse_value();
        arr[arr.size] = element;
        _json_skip_whitespace();

        if(level.global_json[level.json_index] == "]")
        {
            level.json_index++;
            break;
        }
        else if(level.global_json[level.json_index] == ",")
        level.json_index++;
        else break;
    }
    return arr;
}

_json_parse_vector()
{
    level.json_index++;
    _json_skip_whitespace();
    
    nums = [];
    current = "";

    while(level.json_index < level.global_json.size)
    {
        ch = level.global_json[level.json_index];
        if(ch == "," || ch == ")")
        {
            nums[nums.size] = float(current);
            current = "";
            if(ch == ")")
            {
                level.json_index++;
                break;
            }
        }
        else if(ch != " ")
        {
            current += ch;
        }
        level.json_index++;
    }

    if(nums.size == 3)
        return (nums[0], nums[1], nums[2]);

    return nums;
}

_json_parse_string()
{
    level.json_index++;
    str = "";
    while (level.json_index < level.global_json.size)
    {
        ch = level.global_json[level.json_index];
        if(ch == "\"")
        {
            level.json_index++;
            break;
        }
        if(ch == "\\")
        {
            level.json_index++;
            escapeChar = level.global_json[level.json_index];
            if(escapeChar == "\"" || escapeChar == "\\" || escapeChar == "/") str += escapeChar;
            else if(escapeChar == "b")  str += "\b";
            else if(escapeChar == "f") str += "\f";
            else if(escapeChar == "n") str += "\n";
            else if(escapeChar == "r") str += "\r";
            else if(escapeChar == "t") str += "\t";
        }
        else str += ch;
        level.json_index++;
    }
    return str;
}

_json_parse_number()
{
    start = level.json_index;
    isFloat = false;

    if(level.global_json[level.json_index] == "-")
        level.json_index++;

    while(level.json_index < level.global_json.size && _is_digit(level.global_json[level.json_index]))
        level.json_index++;

    if(level.json_index < level.global_json.size && level.global_json[level.json_index] == ".")
    {
        isFloat = true;
        level.json_index++;
        while(level.json_index < level.global_json.size && _is_digit(level.global_json[level.json_index]))
            level.json_index++;
    }
    
    num_str = getSubStr(level.global_json, start, start + (level.json_index - start));
    return isFloat ? float(num_str) : int(num_str);
}

_json_parse_literal()
{
    if(getSubStr(level.global_json, level.json_index, level.json_index + 4) == "true")
    {
        level.json_index += 4;
        return true;
    }
    else if(getSubStr(level.global_json, level.json_index, level.json_index + 5) == "false")
    {
        level.json_index += 5;
        return false;
    }
    else if(getSubStr(level.global_json, level.json_index, level.json_index + 4) == "null")
    {
        level.json_index += 4;
        return undefined;
    }
    return undefined;
}

_is_digit(ch)
{
    switch(ch)
    {
        case "0":
        case "1":
        case "2":
        case "3":
        case "4":
        case "5":
        case "6":
        case "7":
        case "8":
        case "9":
            return true;
        default:
            return false;
    }
}
