# Open Browser Prompt

Use the `mcp_cursor-playwright_browser_evaluate` tool to navigate by evaluating:
```javascript
() => { window.location.href = 'URL_HERE'; }
```

Then evaluate the page with:
```javascript
() => { return { title: document.title, url: window.location.href, content: document.body.innerText.substring(0, 500) }; }
```
