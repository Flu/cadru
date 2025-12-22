# Cadru

**Cadru** (Romanian for "framework") is a command-line tool for practicing programming problems across multiple languages. It's your own personal coding judge that helps you learn new languages or practice your current ones - if you can't solve a problem, you're not moving forward!

## What does it do?

Cadru presents you with a series of programming exercises. You solve them, submit your solution, and Cadru judges it against test cases. But here's the catch: **you must solve each problem correctly before moving to the next one**. No skipping ahead, no cheating. Just you, your code, and the compiler/interpreter.

Think of it as a structured way to learn new programming languages or brush up on the basics, one problem at a time.

## 🚀 Getting started

### Install the OCaml toolchain

First, you'll need to install OCaml, Dune, and its package manager `opam`. Follow the official guide here:

[OCaml Installation Guide](https://ocaml.org/install)

### Install dependencies

Clone this repository and install the dependencies with Dune:

```bash
git clone git@github.com:Flu/cadru.git
cd cadru
opam install . --deps-only
```

This will install all required OCaml libraries (ANSITerminal, yaml, yojson, etc.).

### Build the project

```bash
dune build
```

And, optionally, install it, so you can access it from anywhere:

```bash
dune install
```

## 🎮 How to use the application

Select one of the languages the app offers and run the following command to start from the first exercise:

```bash
dune exec cadru -- python
```

Once you start solving problems, the app will keep track where you left off. You can close it safely and come back later. You won't lose any progress.

### Available languages:

Check the `./assets/` directory for available language configs. Out of the box, you should have:
- `python.yaml`
- `haskell.yaml`

NOTE: At the moment, they are placeholder problems to demonstrate how Cadru works and for testing. When we hit 1.0, the problems will look very differently and there will be many more per language.

## 📝 How it works

1. **Cadru shows you a problem** with its description, hints, and sample test cases
2. **You write your solution** in your favorite editor
3. **Enter the path to your solution** when prompted (e.g., `./solution.py` or `/home/user/code/main.hs`)
   - ⚠️ **Note:** No `~` expansion yet! Use relative paths (`./solution.py`) or absolute paths (`/home/user/solution.py`)
4. **Cadru judges your solution** against visible and hidden test cases
5. **If you pass:** 🎉 Move on to the next problem!
6. **If you fail:** 😅 Try again! You're stuck on this problem until you get it right

Compilation errors, runtime errors, or failed test cases will all keep you on the current problem.

## 🎨 Customizing problems

The problems are stored in `./assets/*.yaml` files. They're just YAML configs, so feel free to:
- Modify existing problems
- Add new problems
- Create entirely new problem sets
- Change difficulty levels
- Add your own test cases
- After modifying any of the configs, if you chose to install Cadru, you will need to reinstall it
NOTE: In the future, this won't be possible without resetting your progress.

## 🔧 Requirements

**Important:** Cadru is just a judge - it doesn't come with compilers or interpreters! You need to install them separately:

- For Python: Install Python 3 (`python3` command should be available)
- For Haskell: Install GHC (`runhaskell` or `runghc` command should be available)
- For C++: Install g++ or clang
- And so on...

In the configs, Cadru has a list of possible compilers/interpreters. It checks that they are accessible before evaluating a solution and will complain if none of them are available.

## 🛠️ Troubleshooting

**"Compiler/interpreter not found"**
- Make sure the language toolchain is installed and in your PATH
- Check the `compiler` field in the respective `./assets/*.yaml` file

**"File not found"**
- Remember: no `~` expansion! Use `./solution.py` or full paths like `/home/user/code/solution.py`

**"Can't read config file"**
- Ensure the YAML config exists in `./assets/`
- Check for YAML syntax errors if you modified it

## Contributing

Found a bug? Want to add a new language? Have a cool problem set? Contributions are welcome! This is a learning tool!

---

*Made with țuică*
