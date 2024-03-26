# Julia script to loop over tutorials and modify the sections into dropdowns. It does the following:

# - Replace any `# ### .*` with the same h3 heading after wrapping with `@@dropdown...@@` and wrap next section (before next `# ## .*`) with `@@dropdown-content...@@`
# - To handle nesting (avoid defining a section going past h2 heading) the file is first split by h2 headings then the logic above is applied
# - To further handle nesting (have h2s collapse as well), the same logic is applied for h2s
# - This is applied to all `tutorial.js` files found in `_literate.jl`
# - Note that an invisible character `U+200E` is used due to a bug that occurs whenever a section ends with a line of code rather than raw text.
# - The script is idempotent (won't modify a file it touched before) so it could be run after a new tutorial is added.

using Pkg
Pkg.activate(temp=true)
import Pkg; Pkg.add("RegularExpressions")
import Pkg; Pkg.add("ReadableRegex")
using RegularExpressions
using ReadableRegex


# modify h2 or h3 headings (depending on pattern) for a single file
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

# so we can split by h2s
function split_keeping_splitter(string, splitter)
    r = Regex(either( look_for("", before = splitter), look_for("", after = splitter)))
    split(string, r)
end

# apply logic on h3s after splitting by h2s then apply it on h2s (introduce collapsables to a single file)
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


# apply dropdown logic to all files
function read_tutorials(tutorials_dir)
    # Ensure existence of the directory
    if !isdir(tutorials_dir)
        error("Directory '$tutorials_dir' does not exist.")
    end

    # Iterate over all files named "tutorial.js" in subdirectories
    for subdir in readdir(tutorials_dir)
        file_path = joinpath(tutorials_dir, subdir, "tutorial.jl")
        if isfile(file_path)
            try
                file = open(file_path, "r")
                content = read(file, String)
                close(file)
                file = open(file_path, "w")
                modified_content = introduce_dropdowns(content)
                write(file, modified_content)
                close(file)
                # Store content in the dictionary
            catch e
                throw("Error reading file '$file_path': $(e)")
            end
        end
    end
end



read_tutorials(joinpath(@__DIR__, "_literate"))
