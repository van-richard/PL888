# shellcheck shell=bash
# Default Theme
# If changes made here does not take effect, then try to re-create the tmux session to force reload.

if patched_font_in_use; then
    TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
    TMUX_POWERLINE_SEPARATOR_LEFT_THIN="" 
    TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=""
    TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=""
fi

# See Color formatting section below for details on what colors can be used here.
TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-'0'}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-'138'}
# shellcheck disable=SC2034
TMUX_POWERLINE_SEG_AIR_COLOR=$(air_color)

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}

# See `man tmux` for additional formatting options for the status line.
# The `format regular` and `format inverse` functions are provided as conveniences

# shellcheck disable=SC2128
if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_CURRENT" ]; then
    TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
        #"${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD:=-'255'} "
        #"#[$(format inverse)]" \
        "  #W " \
        #" #[$(format regular)]" \
        #"${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD:=-'255'} "
        )
fi

# shellcheck disable=SC2128
if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_STYLE" ]; then
    TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
        "$(format regular)"
        )
fi

# shellcheck disable=SC2128
if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_FORMAT" ]; then
    TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
        " #[$(format regular)]" \
        "󱓈   #{?window_flags,#F, }" \
        "#W" 
        )
fi

# Format: segment_name background_color foreground_color [non_default_separator] [separator_background_color] [separator_foreground_color] [spacing_disable] [separator_disable]
#
# * background_color and foreground_color. Color formatting (see `man tmux` for complete list):
#   * Named colors, e.g. black, red, green, yellow, blue, magenta, cyan, white
#   * Hexadecimal RGB string e.g. #ffffff
#   * 'default' for the default tmux color.
#   * 'terminal' for the terminal's default background/foreground color
#   * The numbers 0-255 for the 256-color palette. Run `tmux-powerline/color-palette.sh` to see the colors.
# * non_default_separator - specify an alternative character for this segment's separator
# * separator_background_color - specify a unique background color for the separator
# * separator_foreground_color - specify a unique foreground color for the separator
# * spacing_disable - remove space on left, right or both sides of the segment:
#   * "left_disable" - disable space on the left
#   * "right_disable" - disable space on the right
#   * "both_disable" - disable spaces on both sides
#   * - any other character/string produces no change to default behavior (eg "none", "X", etc.)
#
# * separator_disable - disables drawing a separator on this segment, very useful for segments
#   with dynamic background colours (eg tmux_mem_cpu_load):
#   * "separator_disable" - disables the separator #   * - any other character/string produces no change to default behavior
#
# Example segment with separator disabled and right space character disabled:
# "hostname 33 0 {TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD} 33 0 right_disable separator_disable"
#
# Note that although redundant the non_default_separator, separator_background_color and
# separator_foreground_color options must still be specified so that appropriate index
# of options to support the spacing_disable and separator_disable features can be used

# shellcheck disable=SC1143,SC2128
if [ -z "$TMUX_POWERLINE_LEFT_STATUS_SEGMENTS" ]; then
    TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
        #"time"  \
        #"pwd" \
        #"hostname 33 0" \
        #"mode_indicator 16 255" \
        #"ifstat 237 255" \
        #"ifstat_sys 237 255" \
        #"lan_ip 24 255 ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}" \
        #"vpn 24 255 ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}" \
        #"wan_ip 24 255" \
        #"vcs_branch 29 88" \
        #"vcs_compare 60 255" \
        #"vcs_staged 64 255" \
        #"vcs_modified 9 255" \
        #"vcs_others 245 0" \
    )
fi

# shellcheck disable=SC1143,SC2128
if [ -z "$TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS" ]; then
    TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
        #"earthquake 3 0" \
        #"pwd 89 211" \
        #"macos_notification_count 29 255" \
        #"mailcount 9 255" \
        "now_playing 255 14" \
        #"cpu 240 136" \
        "load 238 138"\ 
        #"tmux_mem_cpu_load 234 136" \
        #"battery 137 127" \
        #"air ${TMUX_POWERLINE_SEG_AIR_COLOR} 255" \
        #"weather 37 255" \
        #"rainbarf 0 ${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR}" \
        "ifstat 241 52" \
        "ifstat_sys 245 52" \
        "mode_indicator 249 52" \
        #"xkb_layout 125 117" \
        #"date_day 235 136" \
        #"date 16 255" \
        #"date 235 255 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
        # "time 235 136 " \
    )
fi
