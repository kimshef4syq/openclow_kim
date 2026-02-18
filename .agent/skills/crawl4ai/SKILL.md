---
name: crawl4ai
description: "Crawl4AI - Open-source LLM-friendly web crawler and scraper. Use when the user needs to: (1) Crawl websites and extract content, (2) Convert web pages to clean Markdown, (3) Extract structured data with LLMs or CSS selectors, (4) Handle JavaScript-rendered pages, (5) Deep crawl websites with BFS/DFS strategies, (6) Process PDFs and media files, (7) Set up web scraping pipelines. Triggers: crawl4ai, web scraping, web crawler, markdown extraction, data extraction."
---

# Crawl4AI

Open-source LLM-friendly web crawler and scraper that turns websites into clean, structured Markdown.

## Quick Start

```bash
# Install
pip install -U crawl4ai
crawl4ai-setup

# Verify
crawl4ai-doctor
```

## Basic Usage

```python
import asyncio
from crawl4ai import AsyncWebCrawler, BrowserConfig, CrawlerRunConfig, CacheMode

async def main():
    async with AsyncWebCrawler() as crawler:
        result = await crawler.arun(url="https://example.com")
        print(result.markdown)

asyncio.run(main())
```

## Core Concepts

### AsyncWebCrawler
Main crawler class for async web crawling.

```python
from crawl4ai import AsyncWebCrawler, BrowserConfig

browser_config = BrowserConfig(
    headless=True,
    verbose=True,
    # Use persistent profile
    user_data_dir="~/.crawl4ai/browser_profile",
    use_persistent_context=True,
)

async with AsyncWebCrawler(config=browser_config) as crawler:
    result = await crawler.arun(url="https://example.com")
```

### CrawlerRunConfig
Configure crawling behavior.

```python
from crawl4ai import CrawlerRunConfig, CacheMode

run_config = CrawlerRunConfig(
    cache_mode=CacheMode.ENABLED,
    word_count_threshold=10,
    screenshot=True,
    pdf=True,
)

result = await crawler.arun(url="https://example.com", config=run_config)
```

## Markdown Generation

### Clean Markdown (Default)
```python
result = await crawler.arun(url="https://example.com")
print(result.markdown)  # Clean, structured markdown
```

### Fit Markdown (Content Filtering)
```python
from crawl4ai.content_filter_strategy import PruningContentFilter, BM25ContentFilter
from crawl4ai.markdown_generation_strategy import DefaultMarkdownGenerator

# Pruning filter - removes noise
filter_strategy = PruningContentFilter(
    threshold=0.48,
    threshold_type="fixed",
    min_word_threshold=0
)

# Or BM25 filter - relevance-based
filter_strategy = BM25ContentFilter(
    user_query="machine learning tutorials",
    bm25_threshold=1.0
)

run_config = CrawlerRunConfig(
    markdown_generator=DefaultMarkdownGenerator(content_filter=filter_strategy)
)
```

## Structured Data Extraction

### LLM-Based Extraction
```python
from crawl4ai import LLMExtractionStrategy, LLMConfig
from pydantic import BaseModel, Field

class Product(BaseModel):
    name: str = Field(..., description="Product name")
    price: str = Field(..., description="Product price")

strategy = LLMExtractionStrategy(
    llm_config=LLMConfig(provider="openai/gpt-4o", api_token="..."),
    schema=Product.schema(),
    extraction_type="schema",
    instruction="Extract all products with their prices"
)

run_config = CrawlerRunConfig(extraction_strategy=strategy)
result = await crawler.arun(url="https://shop.example.com", config=run_config)
products = json.loads(result.extracted_content)
```

### CSS-Based Extraction (No LLM)
```python
from crawl4ai import JsonCssExtractionStrategy

schema = {
    "name": "Products",
    "baseSelector": ".product-item",
    "fields": [
        {"name": "title", "selector": "h2", "type": "text"},
        {"name": "price", "selector": ".price", "type": "text"},
        {"name": "image", "selector": "img", "type": "attribute", "attribute": "src"}
    ]
}

strategy = JsonCssExtractionStrategy(schema)
run_config = CrawlerRunConfig(extraction_strategy=strategy)
```

## Deep Crawling

### BFS Strategy
```python
from crawl4ai.deep_crawling import BFSDeepCrawlStrategy

strategy = BFSDeepCrawlStrategy(
    max_depth=3,
    max_pages=50,
    include_external=False
)

async for result in await crawler.arun("https://example.com", deep_crawl_strategy=strategy):
    print(f"Crawled: {result.url}")
```

### DFS Strategy
```python
from crawl4ai.deep_crawling import DFSCrawlStrategy

strategy = DFSCrawlStrategy(
    max_depth=5,
    max_pages=100
)
```

### Best-First Strategy
```python
from crawl4ai.deep_crawling import BestFirstCrawlingStrategy
from crawl4ai.content_scoring_strategy import CosineStrategy

strategy = BestFirstCrawlingStrategy(
    max_depth=3,
    max_pages=30,
    url_scorer=CosineStrategy(query="machine learning tutorials"),
    threshold=0.3
)
```

### With Crash Recovery (v0.8.0+)
```python
async def save_state(state):
    # Save to Redis/database
    await redis.set("crawl_state", json.dumps(state))

strategy = BFSDeepCrawlStrategy(
    max_depth=3,
    resume_state=loaded_state,  # Continue from checkpoint
    on_state_change=save_state  # Called after each URL
)
```

### Prefetch Mode (Fast URL Discovery)
```python
# 5-10x faster - skips markdown/extraction
config = CrawlerRunConfig(prefetch=True)
result = await crawler.arun("https://example.com", config=config)
# Returns HTML and links only
```

## Advanced Features

### Session Management
```python
# Reuse browser session
async with AsyncWebCrawler() as crawler:
    # First request
    result1 = await crawler.arun("https://example.com/login")
    
    # Second request maintains session (cookies, etc.)
    result2 = await crawler.arun("https://example.com/dashboard")
```

### JavaScript Execution
```python
run_config = CrawlerRunConfig(
    js_code=["""
        (async () => {
            # Scroll to load lazy content
            window.scrollTo(0, document.body.scrollHeight);
            await new Promise(r => setTimeout(r, 1000));
        })();
    """]
)
```

### Virtual Scroll (Infinite Scroll)
```python
from crawl4ai import VirtualScrollConfig

scroll_config = VirtualScrollConfig(
    container_selector="[data-testid='feed']",
    scroll_count=20,
    scroll_by="container_height",
    wait_after_scroll=1.0
)

run_config = CrawlerRunConfig(virtual_scroll_config=scroll_config)
```

### Page Interaction
```python
from crawl4ai import CrawlerRunConfig

run_config = CrawlerRunConfig(
    js_code=["""
        (async () => {
            # Click tabs to load content
            const tabs = document.querySelectorAll('.tab');
            for(let tab of tabs) {
                tab.click();
                await new Promise(r => setTimeout(r, 500));
            }
        })();
    """]
)
```

### Proxy & Authentication
```python
browser_config = BrowserConfig(
    proxy="http://user:pass@proxy:8080",
    # Or
    proxy={
        "server": "http://proxy:8080",
        "username": "user",
        "password": "pass"
    }
)
```

### Stealth Mode
```python
browser_config = BrowserConfig(
    browser_type="undetected",  # Bypass bot detection
    headless=True,
    extra_args=["--disable-blink-features=AutomationControlled"]
)
```

## Extraction Strategies

See [references/extraction/] for detailed guides:
- **LLM-Free Strategies**: CSS/XPath based extraction
- **LLM Strategies**: AI-powered structured extraction
- **Clustering Strategies**: Group similar content
- **Chunking**: Split content for processing

## API Reference

See [references/api/] for detailed API docs:
- **AsyncWebCrawler**: Main crawler class
- **arun()**: Single URL crawling
- **arun_many()**: Multiple URL batch crawling
- **CrawlResult**: Result object structure
- **Strategies**: All extraction strategies

## Docker Deployment

```bash
# Run server
docker run -d -p 11235:11235 --name crawl4ai --shm-size=1g unclecode/crawl4ai:latest

# Access dashboard: http://localhost:11235/dashboard
```

### API Usage
```python
import requests

response = requests.post(
    "http://localhost:11235/crawl",
    json={"urls": ["https://example.com"], "priority": 10}
)
result = response.json()
```

## CLI Usage

```bash
# Basic crawl
crwl https://example.com -o markdown

# Deep crawl
crwl https://example.com --deep-crawl bfs --max-pages 10

# With LLM extraction
crwl https://example.com -q "Extract all product prices"
```

## References

- [README.md](references/README.md) - Project overview
- [index.md](references/index.md) - Documentation index
- [complete-sdk-reference.md](references/complete-sdk-reference.md) - Full API reference
- [api/](references/api/) - API documentation
- [core/](references/core/) - Core features
- [advanced/](references/advanced/) - Advanced features
- [extraction/](references/extraction/) - Extraction strategies

## Common Patterns

### Batch Crawling
```python
urls = ["https://example.com/page1", "https://example.com/page2"]
results = await crawler.arun_many(urls)
```

### Multi-Config Crawling
```python
from crawl4ai import CrawlerRunConfig, MatchMode

configs = [
    CrawlerRunConfig(
        url_matcher=["*docs*"],
        cache_mode="write"
    ),
    CrawlerRunConfig(
        url_matcher=lambda url: 'blog' in url,
        cache_mode="bypass"
    ),
    CrawlerRunConfig()  # Default fallback
]

results = await crawler.arun_many(urls, config=configs)
```

### Error Handling
```python
result = await crawler.arun(url="https://example.com")

if result.success:
    print(result.markdown)
else:
    print(f"Error: {result.error_message}")
```

## Resources

- Docs: https://docs.crawl4ai.com/
- GitHub: https://github.com/unclecode/crawl4ai
- PyPI: https://pypi.org/project/crawl4ai/
