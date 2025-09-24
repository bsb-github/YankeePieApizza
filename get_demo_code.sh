#!/bin/bash

# Clear the terminal
clear

# Prompt for the new base URL
read -p "Enter the new base URL (press Enter to use default 'YOUR_BASE_URL_HERE'): " new_base_url

# Set default if no input is given
new_base_url=${new_base_url:-YOUR_BASE_URL_HERE}

# Prompt for the new appMode (default to 'release' if no input)
read -p "Enter the new AppMode (press Enter to use default 'AppMode.release'): " app_mode

# Set default to 'AppMode.release' if no input is given
app_mode=${app_mode:-release}

# Prompt for the new Google Maps API Key (or use default if empty)
read -p "Enter the new Google Maps API Key for meta-data (press Enter to use default 'YOUR_MAP_KEY_HERE'): " map_key

# Set default if no input is given
map_key=${map_key:-YOUR_MAP_KEY_HERE}

# Prompt for the new Google Sign-In Client Key (or use default if empty)
read -p "Enter the new Google Sign-In Client Key (press Enter to use default 'YOUR_GOOGLE_SIGN_IN_CLIENT_KEY'): " google_sign_in_key

# Set default if no input is given
google_sign_in_key=${google_sign_in_key:-YOUR_GOOGLE_SIGN_IN_CLIENT_KEY}

# Prompt for the new Google Maps API Key for <script> tag (or use default if empty)
read -p "Enter the new Google Maps API Key for the <script> tag (press Enter to use default 'YOUR_MAP_KEY_HEREE'): " script_map_key

# Set default if no input is given
script_map_key=${script_map_key:-YOUR_MAP_KEY_HEREE}

# File path to app_constants.dart
file_path="lib/utill/app_constants.dart"

# AndroidManifest.xml path
manifest_path="android/app/src/main/AndroidManifest.xml"

# Web index.html path
web_index_path="web/index.html"

# Ensure we are in the Git root directory
cd "$(git rev-parse --show-toplevel)"

# Use sed to replace the baseUrl value in app_constants.dart
sed -i '' "s|static const String baseUrl = .*|static const String baseUrl = '$new_base_url';|g" $file_path

# Use sed to replace the appMode value in app_constants.dart
sed -i '' "s|static const AppMode appMode = .*|static const AppMode appMode = AppMode.$app_mode;|g" $file_path

# Use sed to replace only the value inside the quotes for the specific android:name="com.google.android.geo.API_KEY"
# This will match the exact meta-data tag and only change the value of android:value
sed -i '' 's|\(<meta-data android:name="com.google.android.geo.API_KEY" android:value="\)[^"]*\(".*\)|\1'"$map_key"'\2|' $manifest_path

# Use sed to replace the google-signin-client_id in web/index.html
sed -i '' 's|<meta name="google-signin-client_id" content=".*"|<meta name="google-signin-client_id" content="'$google_sign_in_key'"|g' $web_index_path

# Use sed to replace the Google Maps API Key in the <script> tag in web/index.html
# This matches the part after `key=` and before `&`
sed -i '' 's|\(<script async src="https://maps.googleapis.com/maps/api/js?key=\)[^&]*\(&loading=async&callback=Function.prototype"></script>\)|\1'"$script_map_key"'\2|' $web_index_path

# Check if the changes were successful
if grep -q "static const String baseUrl = '$new_base_url';" $file_path && grep -q "static const AppMode appMode = AppMode.$app_mode;" $file_path && grep -q "android:value=\"$map_key\"" $manifest_path && grep -q 'google-signin-client_id' $web_index_path && grep -q "key=$script_map_key" $web_index_path; then
    echo "baseUrl updated to $new_base_url, appMode updated to AppMode.$app_mode, Google Maps API Key updated in meta-data, Google Sign-In Client Key updated, and Google Maps API Key updated in <script> tag"
else
    echo "Failed to update baseUrl, appMode, Google Maps API Key, Google Sign-In Client Key, or Google Maps API Key in <script> tag"
fi

