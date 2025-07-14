#!/bin/bash
set -euo pipefail

# This script downloads a prebuilt Skia artifact from a direct URL (HTTP/HTTPS)
# or a local file path (file://) provided via the SKIA_PREBUILT_URL environment variable.
# It extracts only the libraries to the 'artifacts' directory.
# Headers are expected to be used directly from the Skia source.
#
# Prerequisites:
# - 'curl' utility must be available for HTTP/HTTPS downloads.
# - 'tar' utility must be available for .tar.gz extraction.

# --- Define common paths and variables ---
TARGET_DIR="artifacts"
TMP_DOWNLOAD_DIR="./.tmp_skia_download"
TMP_ARCHIVE_PATH="$TMP_DOWNLOAD_DIR/skia-prebuilt.tar.gz" # Changed to .tar.gz

echo "--- Getting Skia Prebuilt Artifact ---"

# --- Step 0: Clean up previous state and create temp directory ---
echo "Cleaning up existing '$TARGET_DIR' contents..."
rm -rf "$TARGET_DIR"/* || true
mkdir -p "$TARGET_DIR" # Ensure the target directory exists

mkdir -p "$TMP_DOWNLOAD_DIR"
# Ensure the temporary archive is clean before starting
rm -f "$TMP_ARCHIVE_PATH" || true

# --- Get environment variables ---
SKIA_PREBUILT_URL="${SKIA_PREBUILT_URL:-}"

# --- Step 1: Detect OS and Architecture (no longer used as heavily, but kept for consistency) ---
OS_NAME=$(uname -s | tr '[:upper:]' '[:lower:]' | sed 's/darwin/mac/')
ARCH_NAME=$(uname -m | sed 's/x86_64/x64/;s/arm64/arm64/')

# --- Step 2: Verify common prerequisites ---
# Check for tar instead of unzip
if ! command -v tar &> /dev/null; then
    echo "Error: 'tar' utility is not installed. Please install it."
    exit 1
fi

# --- Step 3: Handle download based on SKIA_PREBUILT_URL ---
if [ -n "$SKIA_PREBUILT_URL" ]; then
    echo "SKIA_PREBUILT_URL is set: '$SKIA_PREBUILT_URL'"

    if [[ "$SKIA_PREBUILT_URL" =~ ^https?:// ]]; then
        echo "Detected HTTP/HTTPS URL. Downloading with curl..."
        if ! command -v curl &> /dev/null; then
            echo "Error: 'curl' is not installed. Please install it to download from HTTP/HTTPS."
            exit 1
        fi
        echo "Downloading from: $SKIA_PREBUILT_URL to $TMP_ARCHIVE_PATH"
        if ! curl -L -o "$TMP_ARCHIVE_PATH" "$SKIA_PREBUILT_URL"; then
            echo "Error: Failed to download Skia prebuilt archive from '$SKIA_PREBUILT_URL'."
            rm -rf "$TMP_DOWNLOAD_DIR" # Clean up temp directory on failure
            exit 1
        fi
    elif [[ "$SKIA_PREBUILT_URL" =~ ^file:// ]]; then
        echo "Detected file:// URL. Copying local file..."
        LOCAL_PATH="${SKIA_PREBUILT_URL#file://}" # Remove 'file://' prefix
        echo "Copying from: $LOCAL_PATH to $TMP_ARCHIVE_PATH"
        if [ ! -f "$LOCAL_PATH" ]; then
            echo "Error: Local file not found at '$LOCAL_PATH'."
            rm -rf "$TMP_DOWNLOAD_DIR" # Clean up temp directory on failure
            exit 1
        fi
        if ! cp "$LOCAL_PATH" "$TMP_ARCHIVE_PATH"; then
            echo "Error: Failed to copy local Skia prebuilt archive from '$LOCAL_PATH'."
            rm -rf "$TMP_DOWNLOAD_DIR" # Clean up temp directory on failure
            exit 1
        fi
    else
        echo "Error: Invalid SKIA_PREBUILT_URL format. Must start with 'http://', 'https://', or 'file://'."
        rm -rf "$TMP_DOWNLOAD_DIR" # Clean up temp directory on failure
        exit 1
    fi
else
    echo "Error: SKIA_PREBUILT_URL is not set. This script requires a URL to download or copy the prebuilt artifact."
    exit 1
fi

echo "Successfully obtained artifact at: $(basename "$TMP_ARCHIVE_PATH")"

# --- Step 4: Extract library files from the archive ---
echo "Extracting libraries from '$(basename "$TMP_ARCHIVE_PATH")' to '$TARGET_DIR'..."
# Create artifacts directory
mkdir -p "$TARGET_DIR"
# Extract directly to artifacts directory
if ! tar -xvzf "$TMP_ARCHIVE_PATH" -C "$TARGET_DIR" --strip-components=1; then
    echo "Error: Failed to extract prebuilt Skia archive."
    rm -rf "$TMP_DOWNLOAD_DIR" # Clean up temp directory on failure
    exit 1
fi

# --- Step 5: Cleanup ---
echo "Cleaning up temporary download directory: '$TMP_DOWNLOAD_DIR'..."
rm -rf "$TMP_DOWNLOAD_DIR"

echo "Skia prebuilt artifact successfully obtained and extracted to '$TARGET_DIR'."
echo "--- Getting Prebuilt Complete ---"