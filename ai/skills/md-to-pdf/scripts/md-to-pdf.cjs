#!/usr/bin/env node
/**
 * md-to-pdf — Convert markdown to PDF using crossnote
 *
 * Features:
 * - Mermaid diagrams
 * - Math equations (KaTeX)
 * - Syntax highlighting
 * - Page numbers
 * - GitHub-light theme
 *
 * Usage:
 *   md-to-pdf input.md                     # Creates input.pdf
 *   md-to-pdf input.md output.pdf          # Custom output name
 *   md-to-pdf input.md --open              # Open after creating
 *
 * NOTE: This file is .cjs (CommonJS) on purpose. Crossnote's ESM build has a
 * broken extensionless import (`bit-field/lib/render`) that modern Node
 * rejects. Its CJS build works fine because `require()` resolves extensions.
 */

const { readFileSync, writeFileSync, mkdtempSync, unlinkSync, copyFileSync, existsSync } = require("fs")
const { basename, join, resolve, dirname } = require("path")
const { tmpdir } = require("os")
const { execFile } = require("child_process")
const { Notebook } = require("crossnote")
const matter = require("gray-matter")
const he = require("he")

// Parse command line arguments
const args = process.argv.slice(2)
let inputFile = null
let outputFile = null
let openAfter = false

for (let i = 0; i < args.length; i++) {
  const arg = args[i]
  if (arg === "--open" || arg === "-O") {
    openAfter = true
  } else if (arg === "-o" && args[i + 1]) {
    outputFile = args[++i]
  } else if (!arg.startsWith("-")) {
    if (!inputFile) {
      inputFile = arg
    } else if (!outputFile) {
      outputFile = arg
    }
  }
}

if (!inputFile) {
  console.error("Usage: md-to-pdf input.md [output.pdf] [--open]")
  process.exit(1)
}

// Resolve paths
const inputPath = resolve(inputFile)
if (!existsSync(inputPath)) {
  console.error(`File not found: ${inputPath}`)
  process.exit(1)
}

const outputPath = outputFile
  ? resolve(outputFile)
  : inputPath.replace(/\.md$/, ".pdf")

/**
 * Find Chrome executable
 */
async function findChrome() {
  const candidates = [
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    "/Applications/Chromium.app/Contents/MacOS/Chromium",
    "/usr/bin/google-chrome",
    "/usr/bin/chromium",
    "/usr/bin/chromium-browser",
  ]

  for (const path of candidates) {
    if (existsSync(path)) {
      return path
    }
  }

  throw new Error("Chrome or Chromium not found")
}

/**
 * Generate page numbering config for PDF footer
 */
function getPageNumberConfig(filename) {
  const footerStyles = {
    container: [
      "font-size: 9px",
      "width: 100%",
      "margin: 0",
      "padding: 0 1cm",
      "font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif",
      "display: flex",
      "justify-content: space-between",
      "align-items: center",
    ].join("; "),
    filename: "font-size: 8px; color: #666;",
  }

  return {
    displayHeaderFooter: true,
    headerTemplate: "<div></div>",
    footerTemplate: `
      <div style="${footerStyles.container}">
        <span style="${footerStyles.filename}">${he.encode(filename)}</span>
        <span><span class="pageNumber"></span> / <span class="totalPages"></span></span>
      </div>
    `,
    margin: {
      top: "1cm",
      bottom: "1.5cm",
      left: "1cm",
      right: "1cm",
    },
  }
}

/**
 * Inject page numbering into markdown front-matter
 */
function injectPageNumbering(content, filename) {
  const { data, content: body } = matter(content)

  // Don't override user's existing config
  if (data.chrome || data.puppeteer) {
    return content
  }

  const mergedFrontMatter = {
    ...data,
    chrome: getPageNumberConfig(filename),
  }

  return matter.stringify(body, mergedFrontMatter)
}

/**
 * Main render function
 */
async function renderToPdf() {
  const chromePath = await findChrome()

  const originalContent = readFileSync(inputPath, "utf-8")
  const filename = basename(inputPath)

  const contentWithPageNumbers = injectPageNumbering(originalContent, filename)

  // Use source file's directory as notebook path so relative image paths resolve
  const sourceDir = dirname(inputPath)
  const tempFilePath = join(sourceDir, `.~${filename}`)
  writeFileSync(tempFilePath, contentWithPageNumbers, "utf-8")

  try {
    const notebook = await Notebook.init({
      notebookPath: sourceDir,
      config: {
        previewTheme: "github-light.css",
        codeBlockTheme: "github.css",
        mermaidTheme: "default",
        mathRenderingOption: "KaTeX",
        printBackground: true,
        breakOnSingleNewLine: true,
        enableEmojiSyntax: true,
        enableWikiLinkSyntax: false,
        enableExtendedTableSyntax: false,
        chromePath,
        enableScriptExecution: false,
      },
    })

    const engine = notebook.getNoteMarkdownEngine(`.~${filename}`)
    const generatedPath = await engine.chromeExport({
      fileType: "pdf",
      runAllCodeChunks: false,
    })

    copyFileSync(generatedPath, outputPath)

    try {
      unlinkSync(generatedPath)
    } catch {
      // Ignore cleanup errors
    }

    console.log(`Created: ${outputPath}`)

    if (openAfter) {
      const openCmd = process.platform === "darwin" ? "open" : "xdg-open"
      execFile(openCmd, [outputPath], (err) => {
        if (err) console.error(`Could not open ${outputPath}: ${err.message}`)
      })
    }
  } finally {
    try {
      unlinkSync(tempFilePath)
    } catch {
      // Ignore cleanup errors
    }
  }
}

renderToPdf().catch((err) => {
  console.error(`Error: ${err.message}`)
  process.exit(1)
})
