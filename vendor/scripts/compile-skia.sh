#!/bin/bash
set -euo pipefail

# This script compiles Skia from source and copies the necessary artifacts
# to a 'prefix/skia' directory. It replicates the full source build process
# previously handled across multiple Dune rules and the build-vendor.sh script.

# Usage: scripts/compile-skia.sh <os_name> <arch_name> <lib_ext> <gn_args_file> <git_sync_deps_file>

# Arguments:
#   <os_name>: The target operating system (e.g., mac, linux, windows).
#   <arch_name>: The target architecture (e.g., x64, arm64).
#   <lib_ext>: The library file extension (e.g., a for static, lib for Windows static).
#   <gn_args_file>: Path to the GN arguments file (e.g., config/gn_args.txt).
#                   This path should be relative to the directory from which this script is run.
#   <git_sync_deps_file>: Path to the DEPS file for git-sync-deps (e.g., DEPS).
#                         This path should be relative to the directory from which this script is run.

# Read command-line arguments
OS_NAME="$1"
ARCH_NAME="$2"
LIB_EXT="$3"
GN_ARGS_FILE="$4"
GIT_SYNC_DEPS_FILE="$5"

# --- Argument Validation ---
if [ -z "$OS_NAME" ] || [ -z "$ARCH_NAME" ] || [ -z "$LIB_EXT" ] || [ -z "$GN_ARGS_FILE" ] || [ -z "$GIT_SYNC_DEPS_FILE" ]; then
    echo "Error: Missing arguments."
    echo "Usage: $0 <os_name> <arch_name> <lib_ext> <gn_args_file> <git_sync_deps_file>"
    echo "Example: $0 mac x64 a config/gn_args.txt DEPS"
    exit 1
fi

echo "--- Starting Skia Source Build ---"
echo "Target OS: $OS_NAME, Arch: $ARCH_NAME, Library Extension: $LIB_EXT"
echo "GN Args File: $GN_ARGS_FILE, Git Sync DEPS File: $GIT_SYNC_DEPS_FILE"

# Define important paths relative to the script's execution directory (expected to be project root)
SKIA_SRC_DIR="${SKIA_SRC_DIR:-"skia"}" # Path to the cloned Skia repository, default to skia
SKIA_RELATIVE_DIR="out/$OS_NAME/$ARCH_NAME"
SKIA_OUT_DIR="$SKIA_SRC_DIR/$SKIA_RELATIVE_DIR" # Ninja build output directory
SKIA_PREFIX_INSTALL_ROOT="prefix/skia"   # Final installation directory for Skia artifacts

# Environment variable to control SkShaper (from original build-vendor.sh)
SKIA_ENABLE_SHAPING="${SKIA_ENABLE_SHAPING:-}" # Default to empty string if not set

# --- Step 0: Ensure Skia source is present and synced ---
echo "Syncing Skia dependencies using git-sync-deps..."
if [ ! -d "$SKIA_SRC_DIR" ]; then
    echo "Error: Skia source directory '$SKIA_SRC_DIR' not found. Please clone Skia."
    exit 1
fi

# Copy the DEPS file into the Skia directory as OSKI_DEPS,
# then set GIT_SYNC_DEPS_PATH relative to the Skia directory.
OSKI_DEPS_IN_SKIA="$SKIA_SRC_DIR/OSKI_DEPS"
echo "Copying $GIT_SYNC_DEPS_FILE to $OSKI_DEPS_IN_SKIA..."
cp "$GIT_SYNC_DEPS_FILE" "$OSKI_DEPS_IN_SKIA"

(cd "$SKIA_SRC_DIR" && \
 export GIT_SYNC_DEPS_PATH="OSKI_DEPS" && \
 echo "Running python3 tools/git-sync-deps (GIT_SYNC_DEPS_PATH=$GIT_SYNC_DEPS_PATH)" && \
 python3 tools/git-sync-deps)

# --- Step 1: Generate Ninja build files using GN ---
echo "Generating Ninja build files with GN..."
if [ ! -f "$GN_ARGS_FILE" ]; then
    echo "Error: GN arguments file '$GN_ARGS_FILE' not found."
    exit 1
fi
GN_ARGS=$(cat "$GN_ARGS_FILE")
mkdir -p "$SKIA_OUT_DIR" # Ensure the output directory exists before GN runs
(cd "$SKIA_SRC_DIR" && \
  bin/gn gen "$SKIA_RELATIVE_DIR" --args="$GN_ARGS")

# --- Step 2: Prepare Ninja targets and copy lists (from original build-vendor.sh) ---
NINJA_TARGETS="skia modules/skottie modules/svg"
COPY_LIBS_BASE="libskia libsvg libskottie"

if [[ "$SKIA_ENABLE_SHAPING" = "1" || "$SKIA_ENABLE_SHAPING" = "yes" ]]; then
  echo "SKIA_ENABLE_SHAPING is enabled. Including SkShaper."
  NINJA_TARGETS="$NINJA_TARGETS modules/skshaper"
  COPY_LIBS_BASE="$COPY_LIBS_BASE libskshaper"
else
  echo "SKIA_ENABLE_SHAPING is disabled. Excluding SkShaper."
fi

# --- Step 3: Build Skia using Ninja ---
echo "Building Skia libraries and modules with Ninja..."
ninja -C "$SKIA_OUT_DIR" $NINJA_TARGETS

# --- Step 4: Copy compiled libraries and headers to prefix/skia/ ---
echo "Copying compiled artifacts to '$SKIA_PREFIX_INSTALL_ROOT/'..."

# Create necessary destination directories
mkdir -p "${SKIA_PREFIX_INSTALL_ROOT}/lib"
mkdir -p "${SKIA_PREFIX_INSTALL_ROOT}/include"
mkdir -p "${SKIA_PREFIX_INSTALL_ROOT}/modules"

# Copy compiled libraries
LIBS_CP_COMMAND=""
for lib_name in $COPY_LIBS_BASE; do
  LIBS_CP_COMMAND+="cp $SKIA_OUT_DIR/${lib_name}.$LIB_EXT ${SKIA_PREFIX_INSTALL_ROOT}/lib/ && "
done
# Execute the concatenated copy commands. Remove trailing " && " first.
eval "${LIBS_CP_COMMAND% && }"

# --- Header Copying ---
# Copy the entire 'include' directory contents from skia/include/ to prefix/skia/include/
echo "Copying core Skia headers ($SKIA_SRC_DIR/include/ -> ${SKIA_PREFIX_INSTALL_ROOT}/include/)..."
cp -r "$SKIA_SRC_DIR"/include/* "${SKIA_PREFIX_INSTALL_ROOT}/include/"

# Copy module headers, preserving their path structure under 'modules/'.
# This command finds all 'include' directories within 'skia/modules/' (up to 2 levels deep).
echo "Copying module headers ($SKIA_SRC_DIR/modules/*/include/ -> ${SKIA_PREFIX_INSTALL_ROOT}/modules/*/include/)..."
find "$SKIA_SRC_DIR"/modules/ -maxdepth 2 -type d -name "include" -print0 | while IFS= read -r -d $'\0' module_include_dir_path; do
  # Example: module_include_dir_path might be "skia/modules/svg/include"
  # We want "modules/svg/include" to form the destination path.
  relative_path_from_skia_root="${module_include_dir_path#$SKIA_SRC_DIR/}"
  dest_dir="${SKIA_PREFIX_INSTALL_ROOT}/${relative_path_from_skia_root}"

  mkdir -p "$dest_dir" # Create the destination module include directory
  cp -r "${module_include_dir_path}"/* "$dest_dir"/ # Copy header files
done

echo "--- Skia Source Build Complete ---"
