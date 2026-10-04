#!/usr/bin/env bash

#!/usr/bin/env bash

PYTHON="$(command -v python)"

BIN_DIR="$HOME/.local/bin"

MOD_DIRS=(
	"$HOME/fallout4"
)

STEAM_IDS=(
	"377160"	# fallout 4
)

STEAM_USER="Agge_kun"
STEAM_RESET_DIR="$HOME/projects/steam-reset"

CONFIG_PATH="$HOME/.config/mo2-lint"
CACHE_PATH="$HOME/.cache/mo2-lint"

# 1. kill steam
while true; do
	sudo pkill steam
	sudo pkill Steam
	sleep 1
	s="$(ps aux | grep steam | grep -v grep)"
	S="$(ps aux | grep Steam | grep -v grep)"
	if [[ -z "$s" && -z "$S" ]]; then
		break
	fi
done

# 2. clean mo2-lint
git reset --hard HEAD
git clean -xdf
rm -rvf "$CONFIG_PATH"
rm -rvf "$CACHE_PATH"
for d in "${MOD_DIRS[@]}"; do
	rm -rvf "$d"
done

# 3. steam-reset
pushd "$STEAM_RESET_DIR"
for id in "${STEAM_IDS[@]}"; do
	"$PYTHON" main.py "$id" -u "$STEAM_USER"
done
popd

# 4. build mo2-lint
make _build
install -m 755 dist/mo2-lint "$BIN_DIR"
mkdir -p "$CONFIG_PATH"
cp -r configs/game_info.yml "$CONFIG_PATH/game_info.yml"

echo "AFTER:"
echo "1. start game in steam"
echo "2. mo2-lint install --custom configs/game_info.yml fallout4 ~/fallout4 --script-extender"
