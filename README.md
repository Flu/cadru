# 🎯 Cadru

**Cadru** (Romanian for "framework") is a command-line tool for practicing programming problems across multiple languages. It's your own personal coding judge that helps you learn new languages or practice your current ones - if you can't solve a problem, you're not moving forward!

## What does it do?

Cadru presents you with a series of programming exercises. You solve them, submit your solution, and Cadru judges it against test cases. But here's the catch: **you must solve each problem correctly before moving to the next one**. No skipping ahead, no cheating. Just you, your code, and the compiler/interpreter.

Think of it as a structured way to learn new programming languages or brush up on the basics, one problem at a time.

## 🚀 Getting Started

### Install OCaml Toolchain

First, you'll need to install OCaml, Dune, and its package manager `opam`. Follow the official guide here:

👉 [OCaml Installation Guide](https://ocaml.org/install)

### Install Dependencies

Clone this repository and let Dune handle the dependencies:

```bash
git clone <your-repo-url>
cd cadru
opam install . --deps-only
```

This will install all required OCaml libraries (ANSITerminal, yaml, yojson, etc.).

### Build the Project

```bash
dune build
```

## 🎮 How to Use

### Start from the first exercise:

```bash
dune exec cadru -- python
```

### Start from a specific exercise:

```bash
dune exec cadru -- python --exercise 2
```

### Available languages:

Check the `./assets/` directory for available language configs. Out of the box, you should have:
- `python.yaml`
- `haskell.yaml`
- (add more as you create them!)

## 📝 How It Works

1. **Cadru shows you a problem** with its description and sample test cases
2. **You write your solution** in your favorite editor
3. **Enter the path to your solution** when prompted (e.g., `./solution.py` or `/home/user/code/main.hs`)
   - ⚠️ **Note:** No `~` expansion! Use relative paths (`./solution.py`) or absolute paths (`/home/user/solution.py`)
4. **Cadru judges your solution** against visible and hidden test cases
5. **If you pass:** 🎉 Move on to the next problem!
6. **If you fail:** 😅 Try again! You're stuck on this problem until you get it right

Compilation errors, runtime errors, or failed test cases will all keep you on the current problem. No mercy, no shortcuts!

## 🎨 Customizing Problems

The problems are stored in `./assets/*.yaml` files. They're just YAML configs, so feel free to:
- Modify existing problems
- Add new problems
- Create entirely new problem sets
- Change difficulty levels
- Add your own test cases

The problems included are **placeholders** to demonstrate how Cadru works. Make them your own!

## 🔧 Requirements

**Important:** Cadru is just a judge - it doesn't come with compilers or interpreters! You need to install them separately:

- For Python: Install Python 3 (`python3` command should be available)
- For Haskell: Install GHC (`runhaskell` or `runghc` command should be available)
- For C++: Install g++ or clang
- And so on...

Cadru will check if the required compiler/interpreter exists and report an error if it can't find one. No surprises! 🎪

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

Found a bug? Want to add a new language? Have a cool problem set? Contributions are welcome! This is a learning tool, so let's make it better together.

---

*Made with țuică*
