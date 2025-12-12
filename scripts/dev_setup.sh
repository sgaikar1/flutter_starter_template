#!/bin/bash
set -e

echo "🚀 Flutter Starter Template - Development Setup"
echo "================================================"

# Check for Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first:"
    echo "   https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✓ Flutter found: $(flutter --version | head -n 1)"

# Check Flutter version
REQUIRED_VERSION="3.16.0"
CURRENT_VERSION=$(flutter --version | grep -oP 'Flutter \K[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)

echo "  Current version: $CURRENT_VERSION"
echo "  Required version: $REQUIRED_VERSION+"

# Clean previous builds
echo ""
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo ""
echo "📦 Installing dependencies..."
flutter pub get

# Run code generation
echo ""
echo "🔨 Running code generation..."
if dart run build_runner build --delete-conflicting-outputs; then
    echo "✓ Code generation complete"
else
    echo "⚠️  Code generation failed (this is okay if you haven't added serializable models yet)"
fi

# Set up git hooks
echo ""
echo "🪝 Setting up git hooks..."
HOOKS_DIR=".git/hooks"
if [ -d "$HOOKS_DIR" ]; then
    if [ -f "scripts/pre-commit" ]; then
        cp scripts/pre-commit "$HOOKS_DIR/pre-commit"
        chmod +x "$HOOKS_DIR/pre-commit"
        echo "✓ Pre-commit hook installed"
    else
        echo "⚠️  Pre-commit hook script not found, skipping..."
    fi
else
    echo "⚠️  Not a git repository, skipping git hooks setup"
fi

# Create .env file if it doesn't exist
echo ""
echo "📝 Setting up environment file..."
if [ ! -f .env ]; then
    cp .env.example .env
    echo "✓ Created .env from .env.example"
    echo "  Please update .env with your configuration"
else
    echo "✓ .env file already exists"
fi

# Run flutter doctor
echo ""
echo "🏥 Running flutter doctor..."
flutter doctor

# Final success message
echo ""
echo "✅ Development environment setup complete!"
echo ""
echo "Next steps:"
echo "  1. Update .env with your configuration"
echo "  2. Run 'flutter run' to start the app"
echo "  3. Run 'flutter test' to run tests"
echo ""
echo "For more information, see README.md"
