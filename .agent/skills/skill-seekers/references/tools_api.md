# Skill Seekers Tool API Reference

Detailed parameter documentation for the 25 native MCP tools.

## 🛠 Config Tools
- `generate_config(name, url, description, max_pages=100, unlimited=False, rate_limit=0.5)`
- `list_configs()`: Lists available presets in `configs/`.
- `validate_config(config_path)`: Check JSON for schema errors.

## 🕸 Scraping Tools
- `scrape_docs(config_path, unlimited=False, enhance_local=False, skip_scrape=False, dry_run=False, merge_mode=None)`
- `scrape_github(repo, name=None, description=None, token=None, no_issues=False, no_changelog=False, no_releases=False, max_issues=100, scrape_only=False)`
- `scrape_pdf(config_path=None, pdf_path=None, name=None, description=None, from_json=None)`
- `estimate_pages(config_path, max_discovery=1000, unlimited=False)`: Preview crawl size.

## 🔍 Analysis & Workspace Tools
- `scrape_codebase(directory, output="output/codebase/", depth="deep", languages="", file_patterns="", build_api_reference=False, build_dependency_graph=False)`
- `detect_patterns(file="", directory="", output="", depth="deep", json=False)`: Detect Singleton, Factory, Observer, etc.
- `extract_test_examples(file="", directory="", language="", min_confidence=0.5, max_per_file=10, json=False, markdown=False)`
- `build_how_to_guides(input, output="output/codebase/tutorials", group_by="ai-tutorial-group", no_ai=False, json_output=False)`
- `extract_config_patterns(directory, output="output/codebase/config_patterns", max_files=100, enhance=False, enhance_local=False, ai_mode="none")`

## 📦 Packaging & Delivery Tools
- `package_skill(skill_dir, target="claude", auto_upload=True)`
- `enhance_skill(skill_dir, target="claude", mode="local", api_key=None)`
- `upload_skill(skill_zip, target="claude", api_key=None)`
- `install_skill(config_name=None, config_path=None, destination="output", auto_upload=True, unlimited=False, dry_run=False, target="claude")`

## 🧩 Optimization Tools
- `split_config(config_path, target_pages=1000, strategy="auto", dry_run=False)`
- `generate_router(config_pattern, router_name=None)`: Create hub skills.

## 💾 Source & Vector Tools
- `fetch_config(config_name=None, list_available=False, refresh=False)`
- `export_to_weaviate(skill_dir, output_dir=None)`
- `export_to_chroma(skill_dir, output_dir=None)`
- `export_to_faiss(skill_dir, output_dir=None)`
- `export_to_qdrant(skill_dir, output_dir=None)`
