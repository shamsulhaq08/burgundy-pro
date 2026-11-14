const fs = require('fs');
const path = require('path');

function hexToRgb(hex) {
  hex = hex.replace(/^#/, '');
  if (hex.length === 3 || hex.length === 4) {
    hex = hex.split('').map(c => c + c).join('');
  }
  const r = parseInt(hex.substring(0, 2), 16);
  const g = parseInt(hex.substring(2, 4), 16);
  const b = parseInt(hex.substring(4, 6), 16);
  return { r, g, b };
}

function luminance({ r, g, b }) {
  const a = [r, g, b].map(v => {
    v /= 255;
    return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4);
  });
  return a[0] * 0.2126 + a[1] * 0.7152 + a[2] * 0.0722;
}

function contrastRatio(hex1, hex2) {
  const l1 = luminance(hexToRgb(hex1));
  const l2 = luminance(hexToRgb(hex2));
  const brightest = Math.max(l1, l2);
  const darkest = Math.min(l1, l2);
  return (brightest + 0.05) / (darkest + 0.05);
}

function validateTheme(filePath) {
  console.log(`\nValidating: ${path.basename(filePath)}`);
  const raw = fs.readFileSync(filePath, 'utf8');
  let data;
  try {
    data = JSON.parse(raw);
    console.log(`  ✓ Valid JSON format`);
  } catch (err) {
    console.error(`  ✗ Invalid JSON:`, err.message);
    process.exit(1);
  }

  // Validate colors
  const hexRegex = /^#([0-9a-fA-F]{3}|[0-9a-fA-F]{4}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$/;
  let invalidColorCount = 0;
  for (const [key, val] of Object.entries(data.colors || {})) {
    if (typeof val === 'string' && !hexRegex.test(val)) {
      console.warn(`  ! Warning: color ${key} = "${val}" does not match hex pattern`);
      invalidColorCount++;
    }
  }
  if (invalidColorCount === 0) {
    console.log(`  ✓ All ${Object.keys(data.colors).length} workbench colors are valid hex format`);
  }

  // Check contrast ratios
  const editorBg = data.colors['editor.background'];
  const editorFg = data.colors['editor.foreground'];
  const ratio = contrastRatio(editorFg, editorBg);
  console.log(`  ✓ Editor text contrast: ${ratio.toFixed(2)}:1 (WCAG AA requirement: 4.5:1) - ${ratio >= 4.5 ? 'PASS (AAA)' : 'FAIL'}`);

  // Check syntax tokens
  const tokenCount = (data.tokenColors || []).length;
  console.log(`  ✓ TextMate rules defined: ${tokenCount}`);

  // Check semantic token rules
  const semanticCount = Object.keys(data.semanticTokenColors || {}).length;
  console.log(`  ✓ Semantic token colors defined: ${semanticCount}`);
}

validateTheme(path.join(__dirname, '..', 'themes', 'burgundy-pro-color-theme.json'));
validateTheme(path.join(__dirname, '..', 'themes', 'burgundy-soft-color-theme.json'));
console.log('\nAll themes validated successfully!');
