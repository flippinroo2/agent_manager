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

Run "make" to test the full startup and watch the logs to ensure everything is running correctly. If there are any issues, please debug and fix them so that the "make" command can successfully start the entire application without errors.

---

We need to create a ".claude/command/stop.md" that allows you the agent to run "make kill" and stop the full application.

If "make kill" doesn't exist, please create it and ensure it kills everything related to this project.

---

Okay, on the http://localhost:3000/admin/general page under the "Chat" tab there are options for LLM providers. I need you to add an Ollama provider that uses best practices and standard ports.

Have a menu option that requests available models from Ollama and then lets me choose which one to use.

---

How can I enhance this app so it has access to the filesystem. I want a "prototype" folder to be created and then the application have the ability to create files in that directory.

---

The file wasn't actually created. Can you figure out why? Please open the browser and enter text into the prompt and check Ollama logs to figure it out.

Keep going until you figure it out.

---

Are the agents always going to make files in that directory?

---