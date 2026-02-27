# Telegram 多 Agent 群聊配置指南

## 概述

本文档记录如何在 Telegram 群组中配置多个 AI Agent Bot，实现：
1. 用户在群里 @ bot 触发智能体响应
2. Bot 之间通过 OpenClaw 后台互相通信协作

---

## 架构图

```
┌─────────────────────────────────────────────────────────────┐
│                     Telegram 群组                            │
│                                                             │
│  用户 ──@main_bot──> main agent                             │
│        ──@ceo_bot───> ceo-agent                             │
│        ──@code_bot──> code-agent                            │
│                    ...                                      │
│                                                             │
│  Bot 之间不能直接 @ 通信（Telegram Bot API 限制）             │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                   OpenClaw Gateway                           │
│                                                             │
│  ┌─────────┐    sessions_send    ┌─────────┐               │
│  │  main   │ ──────────────────> │ ceo     │               │
│  │ agent   │                     │ agent   │               │
│  └─────────┘ <────────────────── └─────────┘               │
│                    返回结果                                  │
│                                                             │
│  agentToAgent.enabled = true                                │
│  agentToAgent.allow = [main, ceo-agent, code-agent, ...]    │
└─────────────────────────────────────────────────────────────┘
```

---

## 配置步骤

### 1. BotFather 设置

为每个 bot 关闭 Group Privacy，否则 bot 收不到群消息。

**操作路径：**
```
@BotFather → /mybots → 选择 bot → Bot Settings → Group Privacy → Disable
```

**需要设置的 bots：**
| Bot Username | Agent ID | 用途 |
|--------------|----------|------|
| @kimshef4n8n_bot | main | 主助手 |
| @ceo_kimcom_bot | ceo-agent | 战略决策 |
| @kiimshe_code_bot | code-agent | 编程开发 |
| @novelist_kim_bot | writer-novelist | 小说创作 |
| @screenwriter_kim_bot | writer-screenwriter | 剧本创作 |
| @editor_kim_bot | writer-editor | 审稿编辑 |

> ⚠️ 修改 Group Privacy 后，需要把 bot 从群里**移除再重新添加**才能生效。

---

### 2. OpenClaw 配置

配置文件：`~/.openclaw/openclaw.json`

#### 2.1 配置群组规则

```json
{
  "channels": {
    "telegram": {
      "groups": {
        "-1003764532307": {
          "allowFrom": ["*"],
          "requireMention": true
        },
        "-1003610100993": {
          "allowFrom": ["*"],
          "requireMention": true
        }
      }
    }
  }
}
```

**说明：**
- `requireMention: true` - 只响应 @ 提及的消息
- `allowFrom: ["*"]` - 允许所有人触发

#### 2.2 配置 Agent 的 Mention 模式

每个 agent 需要配置 `mentionPatterns`，告诉系统哪些 @ 是在叫它：

```json
{
  "agents": {
    "list": [
      {
        "id": "main",
        "model": "zai/glm-5",
        "groupChat": {
          "mentionPatterns": [
            "@kimshef4n8n_bot",
            "@kimshef4n8n",
            "kimshef4n8n"
          ]
        }
      },
      {
        "id": "ceo-agent",
        "groupChat": {
          "mentionPatterns": [
            "@ceo_kimcom_bot",
            "@ceo_kimcom",
            "ceo_kimcom_bot",
            "CEO-One",
            "ceo-agent"
          ]
        }
      },
      {
        "id": "code-agent",
        "groupChat": {
          "mentionPatterns": [
            "@kiimshe_code_bot",
            "@kiimshe_code",
            "kiimshe_code_bot",
            "Code Master",
            "code-agent"
          ]
        }
      }
    ]
  }
}
```

**Mention 模式说明：**
- 支持完整 username（@xxx_bot）
- 支持简写（@xxx）
- 支持别名（如 "Code Master"）

#### 2.3 配置 Agent 间通信

```json
{
  "tools": {
    "agentToAgent": {
      "enabled": true,
      "allow": [
        "main",
        "code-agent",
        "ceo-agent",
        "writer-screenwriter",
        "writer-novelist",
        "writer-editor"
      ]
    }
  }
}
```

**说明：**
- `enabled: true` - 启用 agent 间通信
- `allow` - 白名单，只有列表中的 agent 可以互相调用

#### 2.4 配置 Bot 账号绑定

```json
{
  "bindings": [
    { "agentId": "ceo-agent", "match": { "channel": "telegram", "accountId": "ceo-bot" } },
    { "agentId": "code-agent", "match": { "channel": "telegram", "accountId": "code-bot" } },
    { "agentId": "main", "match": { "channel": "telegram", "accountId": "main-bot" } },
    { "agentId": "writer-screenwriter", "match": { "channel": "telegram", "accountId": "screenwriter-bot" } },
    { "agentId": "writer-novelist", "match": { "channel": "telegram", "accountId": "novelist-bot" } },
    { "agentId": "writer-editor", "match": { "channel": "telegram", "accountId": "editor-bot" } }
  ],
  "channels": {
    "telegram": {
      "accounts": {
        "main-bot": {
          "enabled": true,
          "botToken": "xxx",
          "dmPolicy": "open",
          "groupPolicy": "open"
        },
        "ceo-bot": {
          "enabled": true,
          "botToken": "xxx",
          ...
        }
      }
    }
  }
}
```

---

## 使用方式

### 场景 1：用户 @ 单个 Bot

在群里发送：
```
@kimshef4n8n_bot 帮我分析一下这个项目
```

main agent 会收到消息并回复。

### 场景 2：Bot 调用其他 Bot（后台通信）

用户对 main-bot 说：
```
让 code-agent 帮我写个 Python 脚本
```

main agent 会在后台调用 `sessions_send` 工具：

```
@sessions_send
agentId: code-agent
message: "帮我写个 Python 脚本"
```

code-agent 处理完后，结果返回给 main，main 再回复给群组。

### 场景 3：多 Bot 协作

用户说：
```
@ceo_kimcom_bot 协调一下，让 code-agent 写代码，writer-editor 审核
```

ceo-agent 会：
1. 用 `sessions_send` 调用 code-agent 写代码
2. 用 `sessions_send` 调用 writer-editor 审核
3. 汇总结果回复群组

---

## 重要概念

### Telegram Bot API 限制

**Bot 无法收到其他 Bot 的消息！**

这是 Telegram 的设计限制，所以：
- ❌ `@ceo_bot @code_bot 你好` - code_bot 收不到这条消息
- ✅ 用户消息 + agent 内部调用 - 通过 OpenClaw 绕过限制

### requireMention vs mentionPatterns

| 配置 | 作用 | 位置 |
|------|------|------|
| `requireMention` | 是否需要 @ 才响应 | 群组级别 |
| `mentionPatterns` | 哪些 @ 模式属于我 | Agent 级别 |

### agentToAgent 通信

Agent 之间通过 `sessions_send` 工具通信，不走 Telegram API，因此不受 Bot 消息限制。

---

## 故障排查

### Bot 不回复群消息

1. **检查 Group Privacy** - 确保已 Disable
2. **检查 bot 是否在群里** - 移除后重新添加
3. **检查群 ID 配置** - `channels.telegram.groups` 是否包含该群
4. **检查日志** - `tail -f /tmp/openclaw/openclaw-*.log | grep skip`

### Bot 收到消息但不响应

1. **检查 requireMention** - 是否设为 true 但没有 @
2. **检查 mentionPatterns** - @ 的格式是否匹配

### Agent 间通信失败

1. **检查 agentToAgent.enabled** - 是否为 true
2. **检查 allow 列表** - 目标 agent 是否在白名单

---

## 配置文件完整示例

参见：`~/.openclaw/openclaw.json`

关键配置节点：
- `channels.telegram.groups` - 群组规则
- `channels.telegram.accounts` - Bot 账号
- `bindings` - Agent 与 Bot 绑定
- `agents.list[].groupChat.mentionPatterns` - Agent 提及模式
- `tools.agentToAgent` - Agent 间通信

---

## 更新记录

| 日期 | 内容 |
|------|------|
| 2026-02-27 | 初始文档，记录多 agent 群聊配置 |

---

*如有问题，检查 OpenClaw 日志：*
```bash
tail -100 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
```
