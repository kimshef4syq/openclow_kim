---
name: skill-seekers
description: "Convert documentation websites, GitHub repositories, codebases, and PDFs into structured Claude AI skills. Use when you need to: (1) Generate a new AI skill from a URL or repo, (2) Analyze local codebases for design patterns and API examples, (3) Package and distribute skills for LLM platforms, (4) Manage documentation scraping configs and workflows."
---

# Skill Seekers (Professional Edition)

Orchestrate complex documentation scraping and knowledge extraction using native MCP tools.

## � Core Workflows

### 1. Build a Skill from Web Docs
1. **Find Preset**: Use `fetch_config(list_available=true)` to check for official configs.
2. **Fetch**: Use `fetch_config(config_name='react')` to download to `configs/`.
3. **Scrape**: Execute `scrape_docs(config_path='configs/react.json')`.
4. **Deploy**: Use `package_skill(skill_dir='output/react/')`.

### 2. Deep Codebase Analysis
1. **Extract Knowledge**: Use `scrape_codebase(directory='./src')`.
2. **Detect Patterns**: Use `detect_patterns(directory='./src')` to find architecture patterns.
3. **Build Tutorials**: Run `extract_test_examples()` followed by `build_how_to_guides()` to turn tests into docs.

## 🛠 Tool Reference
For detailed parameter lists, error codes, and full tool descriptions, always refer to:
👉 **[tools_api.md](references/tools_api.md)**

## 📁 Environment & Output
- **Primary Output**: `output/<skill-name>/` (Skills & References).
- **Secondary Output**: `tmp/` (Local tests and ephemeral workspace).
- **Conda Env**: Must run in `py310` (Handled automatically by MCP configuration).

## ⚠️ Best Practices
- **Cleanup**: Regularly run `scripts/cleanup_workspace.sh` to remove legacy `configs/` or `output/` folders from root.
- **Tokens**: Configure GitHub/Anthropic tokens using terminal command `conda run -n py310 skill-seekers config`.
