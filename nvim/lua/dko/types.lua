---@alias FeatureGroup 'coc' | 'lsp'

---@alias FeatureProviderKey 'coc' | 'default' | 'fzf' | 'snacks'
---@alias FeatureProvider string | fun()

---@class FeatureMapping
---@field finder_key? string -- key in settings to find finder
---@field shortcut string -- the lhs of a vim mapping
---@field providers table<FeatureProviderKey, FeatureProvider>
