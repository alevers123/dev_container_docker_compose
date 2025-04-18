# shellcheck shell=bash
# Prints the current time.

TMUX_POWERLINE_SEG_TIME_FORMAT="${TMUX_POWERLINE_SEG_TIME_FORMAT:-%H:%M}"

generate_segmentrc() {
  read -r -d '' rccontents <<EORC
# date(1) format for the time. Americans might want to have "%I:%M %p".
export TMUX_POWERLINE_SEG_TIME_FORMAT="${TMUX_POWERLINE_SEG_TIME_FORMAT}"
# Change this to display a default timezone
# Use TZ Identifier like "America/Los_Angeles"
# export TMUX_POWERLINE_SEG_TIME_TZ=""
#Use $TMUX_POWERLINE_TIME_ABRV_1, $TMUX_POWERLINE_TIME_ABRV_2, $TMUX_POWERLINE_TIME_ABRV_3
#to define abbreviations for tree further timezones to display defined by
#$TMUX_POWERLINE_SEG_TIME_MTZ_1, $TMUX_POWERLINE_SEG_TIME_MTZ_2, $TMUX_POWERLINE_SEG_TIME_MTZ_3
EORC
  echo "$rccontents"
}

run_segment() {
  echo "LOC $(TZ="$TMUX_POWERLINE_SEG_TIME_TZ" date +"$TMUX_POWERLINE_SEG_TIME_FORMAT")""\
|$TMUX_POWERLINE_TIME_ABRV_1 $(TZ="$TMUX_POWERLINE_SEG_TIME_MTZ_1" date +"$TMUX_POWERLINE_SEG_TIME_FORMAT")""\
|$TMUX_POWERLINE_TIME_ABRV_2 $(TZ="$TMUX_POWERLINE_SEG_TIME_MTZ_2" date +"$TMUX_POWERLINE_SEG_TIME_FORMAT")""\
|$TMUX_POWERLINE_TIME_ABRV_3 $(TZ="$TMUX_POWERLINE_SEG_TIME_MTZ_3" date +"$TMUX_POWERLINE_SEG_TIME_FORMAT")"
}
