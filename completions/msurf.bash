# Bash completion for msurf. Source this file, or install it through Makefile.

_msurf_complete()
{
    local cur prev command subcommand words
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD - 1]}"
    command="${COMP_WORDS[1]:-}"
    subcommand="${COMP_WORDS[2]:-}"

    case "${prev}" in
        --dir|--subdir|--source|--sd)
            COMPREPLY=( $(compgen -d -- "${cur}") )
            return 0
            ;;
    esac

    case "${command}" in
        sd)
            if [ "${COMP_CWORD}" -eq 2 ]; then
                COMPREPLY=( $(compgen -W 'mount cp import prn print mv move bkp backup all macro-a help --help -h' -- "${cur}") )
                return 0
            fi
            case "${subcommand}" in
                mount)
                    COMPREPLY=( $(compgen -W "$(lsblk -pnro NAME,TYPE | awk '$2 == "part" { print $1 }')" -- "${cur}") )
                    ;;
                cp|import|mv|move)
                    COMPREPLY=( $(compgen -W '--dir --subdir --source --sd --mount --help' -- "${cur}") )
                    ;;
                prn|print|bkp|backup|all|macro-a)
                    COMPREPLY=( $(compgen -d -- "${cur}") )
                    ;;
            esac
            return 0
            ;;
        cp|import)
            COMPREPLY=( $(compgen -W '--dir --subdir --source --sd --mount --help' -- "${cur}") )
            return 0
            ;;
        mount|--mount|-M)
            COMPREPLY=( $(compgen -W "$(lsblk -pnro NAME,TYPE | awk '$2 == "part" { print $1 }')" -- "${cur}") )
            return 0
            ;;
        sd-mv|sdmv|sd-prn|sdprn|sd-bkp|sdbkp)
            COMPREPLY=( $(compgen -d -- "${cur}") )
            return 0
            ;;
        srt|sr|sz)
            if [ "${COMP_CWORD}" -eq 2 ]; then
                COMPREPLY=( $(compgen -W 'dir sd size s10 s60 s200' -- "${cur}") )
            elif [ "${subcommand}" = 'dir' ] || [ "${subcommand}" = 'sd' ]; then
                COMPREPLY=( $(compgen -d -- "${cur}") )
            fi
            return 0
            ;;
        sy|sync|syc)
            if [ "${COMP_CWORD}" -eq 2 ]; then
                words='o1 g1 dvb y21'
                COMPREPLY=( $(compgen -W "${words}" -- "${cur}") )
                COMPREPLY+=( $(compgen -d -- "${cur}") )
            else
                COMPREPLY=( $(compgen -d -- "${cur}") )
            fi
            return 0
            ;;
        m|macro|a|al)
            if [ "${COMP_CWORD}" -eq 2 ]; then
                COMPREPLY=( $(compgen -W 'a b c sd' -- "${cur}") )
            else
                COMPREPLY=( $(compgen -d -- "${cur}") )
            fi
            return 0
            ;;
    esac

    words='sd cp import srt sr sz sync sy syc macro m a al help --help -h'
    COMPREPLY=( $(compgen -W "${words}" -- "${cur}") )
}

complete -o bashdefault -o default -F _msurf_complete msurf
