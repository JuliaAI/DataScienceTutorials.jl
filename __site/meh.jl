using RegularExpressions

function modify_string(input, pattern)
    matches = eachmatch(pattern, input)
    modified_string = ""
    last_end = 1
    
    for match in matches
        modified_string *= input[last_end:match.offset-1]
        if match.match != ""
            if last_end == 1
                modified_string *= "\n# @@dropdown\n$(match.match[1:end-1])\n# @@\n# @@dropdown-content\n"
            else
                modified_string *= "\n# ‎\n# @@\n# @@dropdown\n$(match.match[1:end-1])\n# @@\n# @@dropdown-content\n"
            end
            last_end = match.offset + length(match.match)
        end
    end
    
    modified_string *= input[last_end:end]
    (input == modified_string && return input)
    return modified_string*"\n# ‎\n# @@\n"
end

function split_keeping_splitter(string, splitter)
    r = Regex(either( look_for("", before = splitter), look_for("", after = splitter)))
    split(string, r)
end

function introduce_dropdowns(input::AbstractString)
    # if the string has @@dropdown return it as is
    if occursin(r"@@dropdown", input)
        return input
    end
    chunks = split_keeping_splitter(input, "# ## ")
    for (i, chunk) in enumerate(chunks)
        if chunk !="# ## " 
            chunks[i] = modify_string(chunk, r"(# ### .*\n)")
        end
    end
    modified_string = join(chunks)

    return modify_string(modified_string, r"(# ## .*\n)")
end
