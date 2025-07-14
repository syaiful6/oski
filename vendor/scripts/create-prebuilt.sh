#!/bin/bash
set -euo pipefail

# This script creates a prebuilt tar.gz archive from the compiled Skia artifacts
# for use with SKIA_PREBUILT_URL to avoid rebuilding Skia every time.
#
# The script looks for artifacts in _build/default/vendor/artifacts and packages
# them into a tar.gz file suitable for distribution.
#
# Usage: scripts/create-prebuilt.sh [output_file]
#   output_file: Optional path for the output .tar.gz file
#                Default: skia-prebuilt-{os}-{arch}.tar.gz

# --- Detect OS and Architecture ---
OS_NAME=$(uname -s | tr '[:upper:]' '[:lower:]' | sed 's/darwin/mac/')
ARCH_NAME=$(uname -m | sed 's/x86_64/x64/;s/arm64/arm64/')

# --- Define paths ---
BUILD_ARTIFACTS_DIR="_build/default/vendor/artifacts"
DEFAULT_OUTPUT_FILE="skia-prebuilt-${OS_NAME}-${ARCH_NAME}.tar.gz"
OUTPUT_FILE="${1:-$DEFAULT_OUTPUT_FILE}"

echo "--- Creating Skia Prebuilt Archive ---"
echo "Source: $BUILD_ARTIFACTS_DIR"
echo "Output: $OUTPUT_FILE"
echo "Platform: $OS_NAME-$ARCH_NAME"

# --- Validation ---
if [ ! -d "$BUILD_ARTIFACTS_DIR" ]; then
    echo "Error: Artifacts directory '$BUILD_ARTIFACTS_DIR' not found."
    echo "Please build Skia first with: dune build vendor/"
    exit 1
fi

# Check if there are any library files
if ! find "$BUILD_ARTIFACTS_DIR" -name "*.a" -o -name "*.so" -o -name "*.dylib" -o -name "*.lib" | grep -q .; then
    echo "Error: No library files found in '$BUILD_ARTIFACTS_DIR'."
    echo "Please ensure Skia has been compiled successfully."
    exit 1
fi

# --- Create the archive ---
echo "Creating archive from artifacts..."
# Change to the parent directory of artifacts so the archive contains just the artifacts folder
ARTIFACTS_PARENT_DIR=$(dirname "$BUILD_ARTIFACTS_DIR")
ARTIFACTS_DIR_NAME=$(basename "$BUILD_ARTIFACTS_DIR")

(cd "$ARTIFACTS_PARENT_DIR" && \
 tar -czf "../../../$OUTPUT_FILE" "$ARTIFACTS_DIR_NAME"/*)

# --- Verification ---
if [ -f "$OUTPUT_FILE" ]; then
    echo "Successfully created: $OUTPUT_FILE"
    echo "Archive size: $(du -h "$OUTPUT_FILE" | cut -f1)"
    echo ""
    echo "Contents:"
    tar -tzf "$OUTPUT_FILE" | head -10
    if [ $(tar -tzf "$OUTPUT_FILE" | wc -l) -gt 10 ]; then
        echo "... and $(( $(tar -tzf "$OUTPUT_FILE" | wc -l) - 10 )) more files"
    fi
    echo ""
    echo "To use this prebuilt archive, set:"
    echo "  export SKIA_PREBUILT_URL=\"file://$(pwd)/$OUTPUT_FILE\""
    echo "in your .envrc or environment."
else
    echo "Error: Failed to create archive."
    exit 1
fi

echo "--- Prebuilt Archive Creation Complete ---"