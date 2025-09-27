import { execSync } from 'child_process';

interface ToolInfo {
  execute(...args: any[]): Promise<any>;
}

class ScicalcTool implements ToolInfo {
  async execute(expression: string): Promise<string> {
    try {
      const result = execSync(`numbat --expression '${expression.replace(/'/g, "'\\''")}'`, { encoding: 'utf8' });
      return result.trim();
    } catch (error) {
      return `Error: ${error.message}`;
    }
  }
}

export default new ScicalcTool();