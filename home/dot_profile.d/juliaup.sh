case ":$PATH:" in
*:"$HOME"/.opt/juliaup/bin:*) ;;
*)
    export PATH="$HOME"/.opt/juliaup/bin${PATH:+:${PATH}}
    ;;
esac
