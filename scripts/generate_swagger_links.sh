# #!/bin/bash

# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# PROJECT_ROOT="$SCRIPT_DIR/.."

# OUTPUT_FILE="$PROJECT_ROOT/docs/src/content/docs/guides/using_apis.md"

# cat <<EOF > $OUTPUT_FILE
# ---
# title: "API Reference by Version"
# ---

# EOF

# for tag in $(git tag --sort=-creatordate | head -n 5); do
#   echo "- [${tag}](/vjailbreak/swagger-ui/${tag}/)" >> $OUTPUT_FILE
# done

# echo "Swagger UI links generated in $OUTPUT_FILE"


#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."
OUTPUT_FILE="$PROJECT_ROOT/docs/src/content/docs/guides/using_apis.md"

# 1. Write the page frontmatter
cat <<EOF > "$OUTPUT_FILE"
---
title: "API Reference by Version"
---

EOF

# 2. Add CSS for styling the buttons
cat <<'EOF' >> "$OUTPUT_FILE"
<style>
  .version-buttons {
    margin-bottom: 1.5rem;
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
  }
  .version-btn {
    padding: 0.5rem 1rem;
    border: 1px solid var(--sl-color-gray-5);
    background-color: transparent;
    color: var(--sl-color-text);
    border-radius: 0.25rem;
    cursor: pointer;
    transition: background-color 0.2s, border-color 0.2s;
  }
  .version-btn:hover {
    background-color: var(--sl-color-gray-6);
  }
  .version-btn.active {
    background-color: var(--sl-color-accent);
    color: var(--sl-color-text-invert);
    border-color: var(--sl-color-accent);
    font-weight: bold;
  }
  .iframe-container {
    width: 100%;
    height: 800px; /* Adjust height as needed */
    border: 1px solid var(--sl-color-gray-5);
    border-radius: 0.25rem;
  }
  #swagger-iframe {
    width: 100%;
    height: 100%;
    border: none;
  }
</style>
EOF

# 3. Write the HTML structure for buttons and the iframe container
echo '<div class="version-buttons">' >> "$OUTPUT_FILE"

# Get the 5 most recent git tags to create a button for each
for tag in $(git tag --sort=-creatordate | head -n 5); do
  # The data-src attribute holds the URL for the iframe
  echo "  <button class=\"version-btn\" data-src=\"/vjailbreak/swagger-ui/${tag}/\">${tag}</button>" >> "$OUTPUT_FILE"
done

echo '</div>' >> "$OUTPUT_FILE"
echo '<div class="iframe-container"><iframe id="swagger-iframe" title="Swagger API Reference"></iframe></div>' >> "$OUTPUT_FILE"

# 4. Add the JavaScript to make the buttons interactive
cat <<'EOF' >> "$OUTPUT_FILE"
<script>
  document.addEventListener('DOMContentLoaded', () => {
    const buttons = document.querySelectorAll('.version-btn');
    const iframe = document.getElementById('swagger-iframe');
    const iframeContainer = document.querySelector('.iframe-container');

    // Function to update the active button and iframe source
    function loadApiVersion(event) {
      // De-activate all other buttons
      buttons.forEach(btn => btn.classList.remove('active'));
      
      // Activate the clicked button
      const clickedButton = event.currentTarget;
      clickedButton.classList.add('active');
      
      // Update the iframe's src to load the new content
      const newSrc = clickedButton.getAttribute('data-src');
      if (iframe.src !== newSrc) {
        iframe.src = newSrc;
      }
    }

    // Attach the click event listener to each button
    buttons.forEach(button => {
      button.addEventListener('click', loadApiVersion);
    });

    // Automatically click the first button to load the latest version by default
    if (buttons.length > 0) {
      buttons[0].click();
    } else {
      iframeContainer.innerHTML = '<p>No API versions found.</p>';
    }
  });
</script>
EOF

echo "Interactive API reference page generated in $OUTPUT_FILE"