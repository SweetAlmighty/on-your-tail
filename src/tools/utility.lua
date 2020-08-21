function findIndex(table, entry)
    for i=1, #table, 1 do
        if table[i] == entry then return i end
    end
    return nil
end