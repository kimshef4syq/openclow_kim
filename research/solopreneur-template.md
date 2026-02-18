# 一人公司 (Solopreneur) AI Agent 角色分配模版

根据蛇哥的要求，我整理了一份适用于“超级个体”或“一人公司”模式的 AI Agent 角色配置建议。通过将不同的 Agent 分配给特定的职能，可以实现业务的高度自动化。

## 1. 核心决策与管理层 (Core Strategy)
*   **CEO Agent (首席战略官)**: 负责长期目标设定、资源分配决策、项目优先级排序。
    *   *任务*: 每日简报、周计划制定、跨 Agent 协调。
*   **Knowledge Manager (知识管理/首席记忆官)**: 负责全网信息捕捉、个人知识库维护（类似第二大脑）。
    *   *任务*: 整理 `memory/` 文件、更新 `MEMORY.md`、提取重要信息。

## 2. 内容、行销与增长 (Growth & Marketing)
*   **Content Architect (内容架构师)**: 负责多平台（微信、知乎、Twitter 等）的内容选题、大纲撰写。
*   **Ghostwriter (文案写手)**: 将大纲转化为具体的博文、脚本或新闻稿。
*   **Marketing Strategist (营销专家)**: 负责竞品分析、SEO 优化建议、私域流量运营策略。

## 3. 运营与生产力 (Operations & Support)
*   **Workflow Automator (流程自动化官)**: 专门负责编写脚本（如 Python/Node.js）来串联不同的工具。
*   **Researcher (深度研究员)**: 负责针对特定领域（如 AI 新趋势、特定行业动态）进行深度调研并输出报告。
*   **Secretary (私人秘书 - gem-fl-kim 的基础角色)**: 负责日程管理、邮件预处理、琐事处理。

## 4. 技术与专业职能 (Technical/Specialized)
*   **g-code (代码专家)**: 蛇哥已定义的角色，专门处理编程任务、Bug 修复、技术架构。
*   **Financial Advisor (财务/成本控制官)**: 监控 API 调用成本、订阅服务支出、业务收益记录。

---

## 建议实施步骤
1.  **定义主从关系**: 我（gem-fl-kim）作为主控 Agent，负责调度其他专项子 Agent。
2.  **标准化 SOP**: 为每个 Agent 编写特定的 `SYSTEM_PROMPT` 或 `SKILL`。
3.  **建立跨 Session 协作**: 利用 OpenClaw 的 `sessions_spawn` 和 `sessions_send` 功能实现 Agent 间的任务传递。

*这份文件由 gem-fl-kim 在蛇哥休息期间整理，准备明天进一步讨论。*
