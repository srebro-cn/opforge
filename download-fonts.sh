#!/bin/bash

# Font files to download
fonts=(
  "KaTeX_AMS-Regular"
  "KaTeX_Caligraphic-Bold"
  "KaTeX_Caligraphic-Regular"
  "KaTeX_Fraktur-Bold"
  "KaTeX_Fraktur-Regular"
  "KaTeX_Main-Bold"
  "KaTeX_Main-BoldItalic"
  "KaTeX_Main-Italic"
  "KaTeX_Main-Regular"
  "KaTeX_Math-BoldItalic"
  "KaTeX_Math-Italic"
  "KaTeX_SansSerif-Bold"
  "KaTeX_SansSerif-Italic"
  "KaTeX_SansSerif-Regular"
  "KaTeX_Script-Regular"
  "KaTeX_Size1-Regular"
  "KaTeX_Size2-Regular"
  "KaTeX_Size3-Regular"
  "KaTeX_Size4-Regular"
  "KaTeX_Typewriter-Regular"
)

# Create fonts directory if it doesn't exist
mkdir -p styles/fonts

# Download each font in different formats
for font in "${fonts[@]}"; do
  echo "Downloading $font..."
  curl -L "https://cdn.jsdelivr.net/npm/katex@0.16.0/dist/fonts/$font.woff2" -o "styles/fonts/$font.woff2"
  curl -L "https://cdn.jsdelivr.net/npm/katex@0.16.0/dist/fonts/$font.woff" -o "styles/fonts/$font.woff"
  curl -L "https://cdn.jsdelivr.net/npm/katex@0.16.0/dist/fonts/$font.ttf" -o "styles/fonts/$font.ttf"
done

echo "All fonts downloaded successfully!"