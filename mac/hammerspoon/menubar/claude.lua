---
-- Display claude.ai monthly spend
print("== menubar.claude")

-- Same endpoint Claude Code's /usage calls. Borrows its OAuth token rather
-- than refreshing it — a refresh rotates the token out from under Claude Code.
local USAGE_URL = "https://api.anthropic.com/api/oauth/usage"

local KEYCHAIN_SERVICE = "Claude Code-credentials"

-- Returns the token, or nil and why there isn't one.
local function accessToken()
  local out, ok = hs.execute(
    "/usr/bin/security find-generic-password -s '" .. KEYCHAIN_SERVICE .. "' -w"
  )
  if not ok then
    return nil, "no '" .. KEYCHAIN_SERVICE .. "' item in the keychain"
  end
  -- hs.json.decode throws on bad JSON instead of returning nil.
  local decoded, creds = pcall(hs.json.decode, out)
  if not (decoded and creds) then
    return nil, "'" .. KEYCHAIN_SERVICE .. "' keychain item is not JSON"
  end
  local token = creds.claudeAiOauth and creds.claudeAiOauth.accessToken
  if not token then
    return nil, "'" .. KEYCHAIN_SERVICE .. "' has no claudeAiOauth.accessToken"
  end
  return token
end

local usageLine = "Loading claude.ai usage…"

local function formatMoney(money)
  local amount = money.amount_minor / 10 ^ money.exponent
  local whole, frac = string.format("%.2f", amount):match("^(%d+)%.(%d+)$")
  whole = whole:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
  return "$" .. whole .. "." .. frac
end

-- Logged once per change, not on every 10-minute refresh.
local hiddenReason

-- Created and deleted rather than hidden. hs.menubar.new(false) and
-- returnToMenuBar() go through a detached NSStatusItem, which drops the title
-- and the autosaveName.
local claudeBar
local refresh

local function showBar()
  if claudeBar then
    return
  end
  -- autosaveName lets macOS persist this item's position in the menubar.
  claudeBar = hs.menubar.new(true, "dko.claude")
  claudeBar:setTitle("✳︎")
  claudeBar:setMenu(function()
    -- Deferred: refresh() may delete the bar whose menu is opening.
    hs.timer.doAfter(0, refresh)
    return { { title = usageLine, disabled = true } }
  end)
end

local function hideBar(reason)
  if reason ~= hiddenReason then
    print("menubar.claude: hiding menubar icon, " .. reason)
    hiddenReason = reason
  end
  if claudeBar then
    claudeBar:delete()
    claudeBar = nil
  end
end

refresh = function()
  local token, reason = accessToken()
  if not token then
    hideBar(reason)
    return
  end
  hiddenReason = nil
  showBar()
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

refresh()
local claudeTimer = hs.timer.doEvery(10 * 60, refresh)

local M = {
  name = "claude",
  destructor = function()
    claudeTimer:stop()
    if claudeBar then
      claudeBar:delete()
    end
  end,
}
return M
