#! /bin/bash

show_help() {
  cat <<EOF
Gets current working directory of active window.
In case window is a terminal , it tries to get the
current working directory of the shell it has spawned.

Options:
  -t Filter only terminals
  -h|? Help
EOF

}

TERM_ONLY=0

while getopts "h?t?" opt; do
  case "$opt" in
    h|\?)
      show_help
      exit 0
      ;;
    t)
      TERM_ONLY=1
      ;;
  esac
done

ID=`xdotool getactivewindow`

WM_CLASS=`xprop WM_CLASS -id $ID`
# echo $WM_CLASS

PID_PARENT=`xprop _NET_WM_PID -id $ID | cut -d' ' -f3`

# echo $PID_PARENT

if [[ "$WM_CLASS" =~ "\"URxvt\"" ]]; then
  PID_CHILD=`pgrep -P $PID_PARENT | sed -n 1p `
  PID=$PID_CHILD
  # echo $PID_CHILD
elif [ -n $TERM_ONLY ]; then
  PID=$PID_PARENT
fi

# echo $PID

pwdx $PID | cut -d' ' -f2
