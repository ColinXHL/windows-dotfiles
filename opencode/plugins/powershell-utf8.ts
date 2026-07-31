const utf8Setup = [
  "$utf8 = [System.Text.UTF8Encoding]::new($false)",
  "[Console]::InputEncoding = $utf8",
  "[Console]::OutputEncoding = $utf8",
  "$OutputEncoding = $utf8",
].join("; ")

export default async () => ({
  "tool.execute.before": async (
    input: { tool: string },
    output: { args: { command?: unknown } },
  ) => {
    if (input.tool !== "bash" || typeof output.args.command !== "string") return
    output.args.command = `${utf8Setup}; ${output.args.command}`
  },
})
