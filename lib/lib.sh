

# A Library is intended for use by other scripts, not to be executed directly.

LIB_PATH=$(dirname $(realpath "./${BASH_SOURCE[0]}"))
REPO_PATH=$(realpath "$LIB_PATH/../")
SCRIPT_PATH=$(realpath "$(dirname $0)")
