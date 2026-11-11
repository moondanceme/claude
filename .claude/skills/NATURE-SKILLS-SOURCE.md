# nature-skills 来源

- 上游仓库：https://github.com/Yuan1z0825/nature-skills
- 同步版本：a1a8220366e82ecd8584ea3d7f46cb3969f4b018（2026-11-10）
- 许可证：Apache-2.0（见 NATURE-SKILLS-LICENSE）

`skills/` 下的全部技能目录原样复制到这里（包括其他技能共用的 `nature-shared`）。
它们通过 `../nature-shared/...` 相对路径互相引用，所以必须放在同一个目录下。

## 如何更新

```bash
git clone --depth 1 https://github.com/Yuan1z0825/nature-skills.git /tmp/ns
cp -r /tmp/ns/skills/* .claude/skills/
```
