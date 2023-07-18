module KEGGAPI

using HTTP
using DataFrames

export request, info, list, find, get_image

function request(url::String)
    response = HTTP.get(url)
    return String(response.body)
end

# This function retrieves information about a specific database from the KEGG API.
function info(database::String)
    # Define the URL for the API request.
    url = "https://rest.kegg.jp/info/$database"
    # Make a request to the URL and convert the response to a string.
    response_text = request(url)
    # Split the response text into lines.
    return response_text
end


function list(database::String)
    url = "https://rest.kegg.jp/list/$database"
    response_text = request(url)
    lines = split(response_text, "\n")

    data = [split(line, "\t") for line in lines if line != ""]
    df = DataFrame(Database = [x[1] for x in data], Description = [x[2] for x in data])
    
    return df
end

function find(database::String, query::String)
    url = "https://rest.kegg.jp/find/$database/$query"
    response_text = request(url)
    lines = split(response_text, "\n")

    data = [split(line, "\t") for line in lines if line != ""]
    df = DataFrame(Database = [x[1] for x in data], Description = [x[2] for x in data])
    
    return df
end

function get_image(pathway_id::String, filename::String)
    url = "https://rest.kegg.jp/get/$pathway_id/image"
    response = HTTP.get(url)
    open(filename, "w") do f
        write(f, response.body)
    end
    return filename
end


end