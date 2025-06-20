#! /usr/bin/fish
 
set SEARCH_STRING not_set
set MODE all #DEFAULT TO CONTAINS
 
for ARG in $argv
    switch $ARG
    case '-h' '--help'
        echo 'finds all installed packages matching a specified substring'
        echo ''
        echo 'usage: search-installed-packages <substring> <--option>'
        echo ''
        echo 'options:'
        echo '--begins-with, -b'
        echo '
        return packages that begin with the search string'
        echo ''
        echo '--ends-with, -e'
        echo '
        return packages that end with the search string'
        echo ''
        echo '--contains, -c'
        echo '
        return packages that contain the search string'
        return 1
    case '--begins-with', '-b'
        set MODE begins_with
    case '--ends-with', '-e'
        set MODE ends_with
    case '--contains', '-c'
        set MODE all
    case '*'
        set SEARCH_STRING $ARG
    end #switch $ARG
end #for arg in $argv

if string match -q $SEARCH_STRING 'not_set'
    echo 'no arguments provided'
    return 0
else
    switch $MODE
    case 'begins_with'
        set SEARCH_STRING (string join '' $SEARCH_STRING '*')
    case 'ends_with'
        set SEARCH_STRING (string join '' '*' $SEARCH_STRING)
    case 'all'
        set SEARCH_STRING (string join '' '*' $SEARCH_STRING '*')
    end #switch $MODE
 
    for PACKAGE in (pacman -Q)
        string match $SEARCH_STRING $PACKAGE
    end #for package in (pacman -Q)
end #if set SEARCH_STRING
