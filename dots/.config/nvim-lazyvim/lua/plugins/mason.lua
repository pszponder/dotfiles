return {
  {
    "mason-org/mason.nvim",
    -- Prefer system tools, including NixOS-compatible binaries, over downloads.
    opts = { PATH = "append" },
  },
}
