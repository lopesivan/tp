#!/bin/bash

###############################################################################
# Global vars (I know, evil!)
#
MAX=100
ALL=""
CLEAN=0
DEEP_CLEAN=0
USE_DIA=1
HIGH=0
ARGS=""
QUIET=0

###############################################################################
#
function check_dependencies()
{
    NOT_FOUND=""

    while (($#))
    do
        if ! which $1 > /dev/null 2>&1
        then
            NOT_FOUND="${NOT_FOUND} $1"
        fi
        shift
    done

    if [[ "$NOT_FOUND" != "" ]]
    then
        for iNotFound in ${NOT_FOUND}
        do
            echo "DEPENDENCY NOT MET: $iNotFound"
        done

        printf "\nPlease install the missing dependencies.\n"

        return 1
    fi
}

###############################################################################
#
function process_args()
{
    while [[ $# > 0 && "${1:0:1}" == "-" ]]
    do
        if [[ "$1" == "-a" ]]
        then
            # Capture the log for all, not just the current branch.
            #
            ALL="--all"
        elif [[ "$1" == "-c" ]]
        then
            # Simplify graph by aggregating nodes with only one child.
            #
            CLEAN=1
        elif [[ "$1" == "-cc" ]]
        then
            # Simplify "same as -c", but make sure nodes with more than one
            # parent don't get aggregated with others. (kinda of a sluggish
            # operation).
            #
            CLEAN=1
            DEEP_CLEAN=1
        elif [[ "$1" == "-p" ]]
        then
            # Output as png (not svg)
            #
            USE_DIA=0
        elif [[ "$1" == "-q" ]]
        then
            # Quiet.
            #
            QUIET=1
        elif [[ "$1" == "-high" ]]
        then
            # Highlight the left-parent history of a given branch/tag/hash.
            #
            HIGH=1
            shift
            git log --first-parent --pretty=format:"%H" $1 > tmp.high
        fi

        shift
    done

    if (($# > 0)) &&
       [[ "$(echo $1 | tr -d \"[0-9]\")" == "" ]]
    then
        # If final option is numerical, this is the maximum number of lines to
        # extract from the log.
        #
        MAX=$1
        shift
    fi

    # Pass the rest of the command line arguments to 'git log'.
    #
    ARGS=$*
}

###############################################################################
#
function create_dot_graph()
{
    all_shas=$(git log $ALL --pretty=format:"%H" $ARGS | head -n $MAX)
    all_shas_with_parents=$(git log $ALL --pretty=format:"%H %P" $ARGS | head -n $MAX)
    count=1
    all_tag_branch_shas=""

    echo "digraph graphname {"

    {
        # Add branches and tags
        #
        IFS=$'\n'
        for line in `git branch -a | sed -e 's/^..//' -e 's/ .*//'`
        do
            IFS=$' '
            record=($(git log --pretty=format:"B$count%H %H \"Branch: $line\"" $line | head -n 1))
            ((count++))
            if echo $all_shas | grep -q ${record[1]} > /dev/null
            then
                # Only add branches that reference something else on our graph
                #
                echo ${record[*]}
                all_tag_branch_shas="$all_tag_branch_shas ${record[1]}"
            fi
        done

        IFS=$'\n'
        for line in `git tag`
        do
            IFS=$' '
            record=($(git log --pretty=format:"T$count%H %H \"Tag: $line\"" $line | head -n 1))
            ((count++))
            if echo $all_shas | grep -q ${record[1]} > /dev/null
            then
                # Only add tags that reference something else on our graph
                #
                echo ${record[*]}
                all_tag_branch_shas="$all_tag_branch_shas ${record[1]}"
            fi
        done

        # Get log entries.
        #
        clean_head=""
        clean_next=""
        git log $ALL --topo-order --pretty=format:"%H %P \"%cd: %s\"" --date=short $ARGS | head -n $MAX | while read cLine
        do
            # Cleanup
            #
            shas=($(echo $cLine | cut -d'"' -f1))

            # IF... not doing any cleaning or
            #       sha is not the expected one or sha is merge commit or
            #       sha is referenced by tag/branch or
            #       (deep_clean enabled and sha has more than 1 child)
            #
            if [[ "$CLEAN" != "1" ]] ||
               [[ "${shas[0]}" != "$clean_next" || ${#shas[*]} > 2  ]] ||
               echo $all_tag_branch_shas | grep -q ${shas[0]} ||
               [[ "$DEEP_CLEAN" == "1" && $(echo $all_shas_with_parents | grep -c ${shas[0]}) > 2 ]]
            then
                # If start-point or is merge point... continue as normal,
                # but make sure to close any open loops.
                #
                if [[ "$clean_head" != "" &&
                      "$clean_next" != "" &&
                      "$clean_next" != "$clean_head" ]]
                then
                    echo "$clean_head $clean_next  \"...\""
                fi

                clean_next=""
                clean_head=${shas[1]}
                echo $cLine
            fi

            clean_next=${shas[1]}
        done

        # Adding trailing newline (echo) because "git log" doesn't provide one,
        # and this causes the while statement to leave out the last line.
        #
        echo
    } | grep . | while read line
    do
        shas=($(echo $line | cut -d'"' -f1))
        label=$(echo $line | cut -d'"' -f2)

        if [[ "${shas:0:1}" == "B" ]]
        then
            echo "    \"${shas[0]:0:5}\" [style=\"filled\"];"
            echo "    \"${shas[0]:0:5}\" [fillcolor=\"green\"];"
            echo "    \"${shas[0]:0:5}\" [label=\"${label:0:50}\"];"
        elif [[ "${shas:0:1}" == "T" ]]
        then
            echo "    \"${shas[0]:0:5}\" [style=\"filled\"];"
            echo "    \"${shas[0]:0:5}\" [fillcolor=\"yellow\"];"
            echo "    \"${shas[0]:0:5}\" [label=\"${label:0:50}\"];"
        else
            echo "    \"${shas[0]:0:5}\" [label=\"${shas[0]:0:5}\n${label:0:50}\"];"
        fi

        #######################################################################
        # Highlight nodes.
        #
        if [[ "$HIGH" == "1" ]] &&
           grep -q ^${shas[0]:0:5} tmp.high
        then
            echo "    \"${shas[0]:0:5}\" [style=\"filled\"];"
            echo "    \"${shas[0]:0:5}\" [fillcolor=\"pink\"];"
        fi


        for ((i=1;i<${#shas[*]};++i))
        do
            echo "    \"${shas[0]:0:5}\" -> \"${shas[$i]:0:5}\";"
        done
    done

    echo "}"
}

function main()
{
    if ! check_dependencies dot dia eog git sed cut
    then
        return 1
    fi

    process_args $*
    create_dot_graph > tmp.dot

    # Invoke "dot" and show graph
    #
    if [[ "$USE_DIA" == "1" ]]
    then
        dot -Tsvg -o out.svg tmp.dot

        if [[ "$QUIET" != "1" ]]
        then
            dia out.svg
        fi
    else
        dot -Tpng -o out.png tmp.dot

        if [[ "$QUIET" != "1" ]]
        then
            eog out.png
        fi
    fi
}

main $*
