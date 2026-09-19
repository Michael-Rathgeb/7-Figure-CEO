# 01_intake — collect the facts that shape the stack

One job: turn a short conversation into `answers.md`.

## Inputs
- Working (this run): the person, in the terminal
- Reference (every run): references/questions.md
- Reference (every run): ../../_shared/rules.md
- Reference (every run): ../../_templates/answers.md

Do NOT load: agent cards, target cards, component cards. You do not need to know how Hermes works to ask which agent they want.

## Process
1. Ask the questions in `references/questions.md`, two or three at a time, in the person's words. Offer the defaults. Skip any the person already answered.
2. Derive the run slug: `<agent>-<target>`, for example `openclaw-vps`. If that slug already has an `output/` folder, ask whether this is a fresh deploy or a redo.
3. Copy `_templates/answers.md` to `output/<run>/answers.md` and fill every field. Unknown stays `unknown`, never a guess.
4. Ask for no secrets. Record only which secrets will be needed, by name.

## Outputs
- answers.md → output/<run>/

## Human check
The person reads `answers.md` top to bottom and says "yes" or edits it in place. The next stage reads whatever is here.
