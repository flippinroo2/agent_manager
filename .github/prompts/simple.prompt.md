---
name: 'Simple Prompt'
agent: agent
model: Claude Opus 4.6 (copilot)
---

Okay, I want to create a Makefile for this project that has commands to run all features in this application. Create a simple "make" command that fully starts everything.

I want to be sure to use "concurrently" npm from the root of the project to run all the commands at once in a single terminal.

So create the Makefile with all commands and ensure there's a simple "make" command that starts everything using "concurrently". Additionally, if there are dependencies not installed have the "make" command also install those dependencies before starting everything. (Use sub-commands for the installation parts)

Additionally, I want to create a ".claude/commands" file called "start" that will be able to run the "make" command and start the full application to be used by the agent.

---