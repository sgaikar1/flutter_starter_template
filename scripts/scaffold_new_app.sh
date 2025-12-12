#!/bin/bash

# Script to scaffold a new app from this template
# Usage: ./scripts/scaffold_new_app.sh --name "App Name" --package "com.example.app"

set -e

# Default values
PROJECT_NAME=""
PACKAGE_NAME=""
ORG_NAME="My Organization"
PRIMARY_COLOR="#6200EE"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --name)
      PROJECT_NAME="$2"
      shift 2
      ;;
    --package)
      PACKAGE_NAME="$2"
      shift 2
      ;;
    --org)
      ORG_NAME="$2"
      shift 2
      ;;
    --color)
      PRIMARY_COLOR="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 --name <name> --package <package> [--org <org>] [--color <color>]"
      exit 1
      ;;
  esac
done

# Validation
if [ -z "$PROJECT_NAME" ]; then
    echo "❌ Error: --name is required"
    echo "Usage: $0 --name <name> --package <package> [--org <org>] [--color <color>]"
    exit 1
fi

if [ -z "$PACKAGE_NAME" ]; then
    # Generate package name from project name
    PACKAGE_NAME="com.example.$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')"
    echo "⚠️  No package name provided, using: $PACKAGE_NAME"
fi

echo "🎨 Flutter App Scaffolder"
echo "========================"
echo "Project Name: $PROJECT_NAME"
echo "Package Name: $PACKAGE_NAME"
echo "Organization: $ORG_NAME"
echo "Primary Color: $PRIMARY_COLOR"
echo ""

# Generate snake_case project name for folder
FOLDER_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

# Confirm
read -p "Create new app with these settings? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 1
fi

echo ""
echo "🚀 Creating $PROJECT_NAME..."

# Create new directory
NEW_DIR="../${FOLDER_NAME}"
if [ -d "$NEW_DIR" ]; then
    echo "❌ Error: Directory $NEW_DIR already exists"
    exit 1
fi

# Copy template
echo "📁 Copying template files..."
cp -r . "$NEW_DIR"

# Change to new directory
cd "$NEW_DIR"

# Remove git history
rm -rf .git

# Replace template variables in files
echo "🔄 Replacing template variables..."

# Function to replace in file
replace_in_file() {
    local file="$1"
    if [ -f "$file" ]; then
        sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$file"
        sed -i.bak "s/{{PACKAGE_NAME}}/$PACKAGE_NAME/g" "$file"
        sed -i.bak "s/{{ORG_NAME}}/$ORG_NAME/g" "$file"
        sed -i.bak "s/{{PRIMARY_COLOR}}/$PRIMARY_COLOR/g" "$file"
        sed -i.bak "s/#6200EE/$PRIMARY_COLOR/g" "$file"
        sed -i.bak "s/0xFF6200EE/0xFF${PRIMARY_COLOR:1}/g" "$file"
        sed -i.bak "s/flutter_starter_template/$FOLDER_NAME/g" "$file"
        rm "${file}.bak"
    fi
}

# Replace in all relevant files
find . -type f \( \
    -name "*.dart" -o \
    -name "*.yaml" -o \
    -name "*.md" -o \
    -name "*.arb" -o \
    -name "*.sh" \
\) -not -path "*/\.*" -not -path "*/build/*" | while read file; do
    replace_in_file "$file"
done

echo "✓ Template variables replaced"

# Initialize git
echo "🔧 Initializing git repository..."
git init
git add .
git commit -m "Initial commit from Flutter starter template"

echo ""
echo "✅ Success! Your new Flutter app is ready at: $NEW_DIR"
echo ""
echo "Next steps:"
echo "  cd $NEW_DIR"
echo "  ./scripts/dev_setup.sh"
echo "  flutter run"
echo ""
