#!/bin/bash

# Define the path to your Flutter app's pubspec.yaml file
PUBSPEC_PATH="pubspec.yaml"

# Get the current version number from the pubspec.yaml file
CURRENT_VERSION=$(grep "version:" $PUBSPEC_PATH | awk '{print $2}' | tr -d '\n')

# Split the version number into major, minor, and patch components
IFS='+' read -ra VERSION_PARTS <<< "$CURRENT_VERSION"

# Increment the patch version by 1
NEW_BUILD_NUMBER=$((VERSION_PARTS[1] + 1))

# Update the version number with the new patch version
NEW_VERSION="${VERSION_PARTS[0]}+$NEW_BUILD_NUMBER"

# Update the pubspec.yaml file with the new version number
sed -i "" "s/version: $CURRENT_VERSION/version: $NEW_VERSION/" $PUBSPEC_PATH

# Print the new version number
echo "Version updated to: $NEW_VERSION"

#flutter build ipa

flutter build appbundle --dart-define="ENV_R=PROD"