---
-- Display claude.ai monthly spend
print("== menubar.claude")

-- Same endpoint Claude Code's /usage calls. Borrows its OAuth token rather
-- than refreshing it — a refresh rotates the token out from under Claude Code.
local USAGE_URL = "https://api.anthropic.com/api/oauth/usage"

local function accessToken()
  local out, ok = hs.execute(
    "/usr/bin/security find-generic-password -s 'Claude Code-credentials' -w"
  )
  if not ok then
    return nil
  end
  local creds = hs.json.decode(out)
  return creds and creds.claudeAiOauth and creds.claudeAiOauth.accessToken
end

-- autosaveName lets macOS persist this item's position in the menubar.
-- Starts hidden; refresh() shows it once there's a token.
local claudeBar = hs.menubar.new(false, "dko.claude")
claudeBar:setTitle("✳︎")

local usageLine = "Loading claude.ai usage…"

local function formatMoney(money)
  local amount = money.amount_minor / 10 ^ money.exponent
  local whole, frac = string.format("%.2f", amount):match("^(%d+)%.(%d+)$")
  whole = whole:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
  return "$" .. whole .. "." .. frac
end

local function refresh()
  local token = accessToken()
  if not token then
    claudeBar:removeFromMenuBar()
    return
  end
  claudeBar:returnToMenuBar()
  hs.http.asyncGet(USAGE_URL, {
    ["Authorization"] = "Bearer " .. token,
    ["anthropic-beta"] = "oauth-2025-04-20",
  }, function(status, body)
    local usage = status == 200 and hs.json.decode(body)
    local spend = usage and usage.spend
    if not (spend and spend.used and spend.limit) then
      usageLine = "claude.ai usage unavailable (HTTP " .. status .. ")"
      return
    end
    usageLine = string.format(
      "%s of %s spent · %d%%",
      formatMoney(spend.used),
      formatMoney(spend.limit),
      spend.percent
    )
  end)
end

claudeBar:setMenu(function()
  refresh()
  return { { title = usageLine, disabled = true } }
end)

refresh()
local claudeTimer = hs.timer.doEvery(10 * 60, refresh)

local M = {
  name = "claude",
  destructor = function()
    claudeTimer:stop()
    claudeBar:delete()
  end,
}
return M
