declare TASK_LAST

###
# Overload command `task`.
###
function task
{
    if [ $# -eq 1 ]; then
        if [ $1 = sh ]; then
            tasksh
        elif [ $1 = stop ]; then
            # Stop the first active task.
            id=$(__task_get_active_task)
            TASK_LAST="$id"
            command task "$id" stop
        elif [ $1 = continue ]; then
            # Continue the last task stopped with no args.
            command task "$TASK_LAST" start
        elif [ $1 = done ]; then
            id=$(__task_get_active_task)
            TASK_LAST="$id"
            # Done the last task stopped with no args.
            command task "$TASK_LAST" done
        else
            command task "$@"
        fi
    elif [ $# -ge 2 ]; then
        if [ $2 = note ]; then
            id="$1"
            if [ $# -eq 3 ] && [ $3 = view ]; then
                tasknote "$id" view
            else
                tasknote "$id"
            fi
        else
            command task "$@"
        fi
    else
        command task "$@"
    fi
}

function __task_get_active_task
{
    task active | sed -n '/ID/{n;n;p;}' | awk '{print $1}'
}
