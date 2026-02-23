# Telegram Bot 群聊配置全流程

## 一、创建 Bot

1. 打开 @BotFather
2. 发 `/newbot` → 按提示取名字和 username
3. 记住 bot token（格式：`123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11`）

## 二、必做配置（两个关键！）

### 1. 允许加群
```
/setjoingroups → 选 bot → Enable
```

### 2. 关闭隐私模式（否则看不到群消息）
```
/setprivacy → 选 bot → Disable
```

⚠️ **这两步不设置，bot 加了群也收不到消息！**

## 三、配置 OpenClaw

### 1. 在 openclaw.json 添加 account
```json
"channels": {
  "telegram": {
    "accounts": {
      "your-bot-name": {
        "enabled": true,
        "botToken": "你的bot token",
        "groupPolicy": "open",
        "dmPolicy": "open"
      }
    }
  }
}
```

### 2. 配置 bindings（绑定 agent）
```json
"bindings": [
  {
    "agentId": "ceo-agent",
    "match": {
      "channel": "telegram",
      "accountId": "your-bot-name"
    }
  }
]
```

### 3. 重启 Gateway
```bash
openclaw gateway restart
```

## 四、加 Bot 进群

1. **先私聊**：在 Telegram 搜索 bot @username，发 `/start`
2. **用链接加群**（比搜索更可靠）：
   ```
   https://t.me/你的botusername?startgroup=true
   ```
3. 点链接 → 选择群 → 添加

## 五、验证

发消息到群里：
- **@mention bot** → bot 应自动回复

查看日志：
```bash
tail -f /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log | grep 群ID
```

## 常见问题

| 问题 | 原因 | 解决 |
|------|------|------|
| 加群时搜不到 bot | `can_join_groups: false` | BotFather `/setjoingroups` → Enable |
| @mention 不回复 | Privacy mode 开着 | BotFather `/setprivacy` → Disable |
| 消息收到但跳过 | groupPolicy 是 allowlist | 改成 `open` |
| 群迁移换 ID | 普通群升级 supergroup | 更新配置里的群 ID |

## 关键命令速查

```bash
# 检查 bot 状态
curl "https://api.telegram.org/bot<TOKEN>/getMe"

# 重启 Gateway
openclaw gateway restart

# 查看日志
tail -100 /tmp/openclaw/openclaw-2026-02-23.log
```
