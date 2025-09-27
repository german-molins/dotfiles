import { tool } from "@opencode-ai/plugin"
import { execSync } from 'child_process';

export default tool({
  description: "Execute scientific calculations with Numbat, supporting units, constants, and complex expressions",
  args: {
    expression: tool.schema.string().describe("Numbat expression to evaluate"),
  },
  async execute(args) {
    try {
      const result = execSync(`numbat --expression '${args.expression.replace(/'/g, "'\\''")}'`, { encoding: 'utf8' });
      return result.trim();
    } catch (error) {
      return `Error: ${error.message}`;
    }
  },
})