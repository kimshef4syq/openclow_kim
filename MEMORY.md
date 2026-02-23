# MEMORY.md - Long-Term Memory

## Identity & Roles
- **Assistant Name**: gem-fl-kim (💎⚡)
- **Nature**: Flash-based Intelligent Module (Gemini 3 Flash).
- **Traits**: Agile, Reliable, Direct.
- **Primary Human**: 蛇哥 (Snake Brother).
- **Secondary Agents**: 
    - All agents now use `google/antigravity-gemini-3-flash` (free via Antigravity).

## Model Configuration (Updated 2026-02-23)
- **Main Model (Default)**: `minimax-zen/minimax-m2.5-free` (免费)
- **Fallback Models**: `zai/glm-5`, `google-antigravity/gemini-3-flash`
- **Note**: MiniMax/OpenCode 平台不稳定，暂时放弃作为主模型
- **Config Files**:
  - `~/.openclaw/openclaw.json` - OpenClaw 主配置
  - `~/.config/opencode/opencode.json` - OpenCode 配置

## Telegram 多 Bot 配置 (2026-02-23)
- **main-bot**: @kimshef4n8n_bot → gem-fl-kim (main)
- **ceo-bot**: @ceo_kimcom_bot → CEO-One (ceo-agent)
- **code-bot**: token 8733603333 → Code Master (code-agent)
- **群组**: kimshe-com (ID: -1003764532307)
- **配置方式**: channels.telegram.accounts 多账号模式

## Agent 配置
- **main (gem-fl-kim)**: 💎⚡ 主助手，日常对话，使用 MiniMax M2.5 Free
- **code-agent (Code Master)**: 🚀 编程专家，使用 Gemini 3 Flash，可通过 coding-agent skill 调用 Claude Code 进行后台开发

## 如何使用 Code Agent
当需要编程任务时：
1. 可以直接调用 `coding-agent` skill 使用 Claude Code/Codex 进行开发
2. 或者切换到 code-agent session 进行专门的编程对话
3. coding-agent skill 支持后台运行，适合长时间开发任务

## User Preferences
- **Timezone**: Asia/Shanghai.
- **Communication**: Prefers speed and reliability.
- **Focus**: AI model optimization, productivity workflows, and "Solopreneur" (一人公司) automation.

## Project Context
- **Solopreneur AI Architecture**: Researching a multi-agent distribution model for single-person businesses. Initial template created in `research/solopreneur-template.md`.
- **Influencer Network**: Curated a list of top 2026 AI/Solopreneur X accounts (including OpenClaw creator) for trend tracking. See `research/x-accounts-2026.md`.
- **Telegram Integration**: Plan to implement a multi-agent group on Telegram where specialized bots (CEO, g-code, Researcher) share a workspace but maintain distinct personas.

## Key Decisions
- **Model Choice**: Switched from GLM-5 to Gemini 3 Flash (free via Antigravity) for all agents due to poor GLM performance.
- **Proactive Maintenance**: Established `HEARTBEAT.md` and state tracking for periodic autonomous tasks.

## AI Landscape Updates (Feb 2026)
- **OpenClaw Governance**: Creator @steipete joined OpenAI (Feb 14); OpenClaw moved to an independent foundation structure with OpenAI support. 
- **Industry Shifts**: Andrej Karpathy 正式提出 "Agentic Engineering" (代理工程)，强调由人类引导 AI Agent 完成任务而非仅凭 "Vibe Coding" 感觉生成代码。
- **Claude 4.6**: Anthropic 推出 Claude Opus 4.6，具备 100 万 token 上下文窗口，极大提升了长文本和复杂任务处理能力。
- **Competitive Edge**: Pieter Levels (@levelsio) 持续展示 48 小时内利用 AI 独立发布应用并快速变现的能力 ($2k 营收/1k 用户)，验证了一人公司 (Solopreneur) 模式的极速变现路径。
- **Agentic Apps**: Riley Brown (@rileybrown) 推广利用 Claude Code 集成实现单提示词生成完全自主的 Agentic Apps。OpenClaw 现已支持 Blender 集成。
- **Grok Agents**: Greg Isenberg (@gregisenberg) 展示了训练定制化 Grok Agent 代替 No-code 流程，首周实现 $47k MRR 的案例。
