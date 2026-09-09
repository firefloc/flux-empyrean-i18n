# flux-empyrean-i18n

A community translation toolkit for **Flux Empyrean** (ChillCash, Godot 4.7), shipping
with a complete French translation.

The game has **no localisation layer** — no `.translation` files, no CSV, no
`TranslationServer`. Every string is hardcoded in scripts, scenes, and one data
script. Translating it means rewriting text at runtime, and above all knowing **which
strings you are not allowed to rewrite**.

That is what this toolkit is for. The French text is the least interesting part of it.

> ⚠️ **Spoilers.** `web/index/verrous.json`, `game/vigenere_keys.json` and
> `game/locks_manual.json` list puzzle answers, cipher keys and acrostic solutions in
> plain text. Don't open them if you haven't finished the game.

---

## Three ways in

| You are | What you do | What you need |
|---|---|---|
| **A player** | Open the page, pick a language, point it at your game folder. | A browser and the GDPatch loader. No terminal. |
| **A translator** | Open `web/index.html`, load your game file, fix strings, propose them. | A browser. Nothing installed. |
| **A tinkerer** | Build locally to add a language, or to replay the in-game puzzle checks. | Godot 4.7, Python 3, the GDPatch loader. |

The player path is the one that matters, and it is the one that used to be broken.
The mod is **220 KB and contains no game file at all**: at first launch it makes the
game itself build the translated scenes from the player's own copy. Details in
[Architecture](#architecture).

---

## Read this before installing

**This translation was produced by an AI, before anyone had finished the game.** No
one has played the French version end to end. Concretely:

- Puzzle logic was read out of **decompiled code**, not discovered by playing. All
  fourteen input points were inventoried at the source, and six of them were tested
  in-game by injection: they accept French and reject a wrong answer. That is a real
  result, but it is not a playthrough.
- Documents were translated without knowing where they sit in the progression. A
  translator who has finished the game will see nuances none of us saw — and fixing a
  document is a one-line change in `locales/fr/`.
- Cross-cutting decisions (register, place names, coined words) are settled and
  justified in `locales/fr/arbitrages.json` and `arbitrages_2.json`. They are
  debatable; what matters is that they are **applied uniformly**, which is the only
  thing that counts in a game built on cross-references between texts.

The general bias is **gameplay over immersion**: wherever an elegant phrasing put a
puzzle at risk, the puzzle won.

---

## What must never be translated

This is the heart of the problem, and the reason this toolkit exists.

### Document titles and location names

Not a style choice — the code forces it. `Scripts/journal.gd` line 38:
`open_screen()` calls `set_displayed(title.text)`, so it **reads back the displayed
string** and uses it as a dictionary key (`if choice in Texts.texts.keys()`). A
translated title falls through to the `else` branch, and the journal opens the wrong
panel every time it is reopened.

Two corroborations: `Locations.discoveries` is keyed by the English name and
**serialised as-is into the save file** — translating those keys invalidates every
save in progress — and 74 `LocationManager.discover("<english name>")` calls are
hardcoded across location scripts.

The accepted consequence: place names stay English inside French sentences. That is
the price of a working journal.

### Cipher blocks and constructed languages

The player types a key into the journal, and `Passage.decrypt()` applies a Vigenère
cipher to the displayed page **after stripping everything that is not a letter**. One
added letter shifts the entire decrypted message.

`tools/build_frozen.py` finds **23** of these: twelve Vigenère blocks, the constructed
Xeretic language, and rebuses in leetspeak and reversed words. They are copied
byte for byte. Doubt favours freezing — a wrongly frozen segment leaves one English
line, a wrongly translated one breaks a puzzle with no error message.

The six plaintexts whose key is known get their translation **below** the decrypted
text, never in place of it: the English plaintext stays intact, so the key does too.

### Answer words

The game compares typed input against English strings. `tools/build_locks.py` finds
**fourteen input points** in the decompiled sources, in two regimes with opposite
consequences:

| Regime | Form | Consequence |
|---|---|---|
| substring | `answer in input.to_lower()` | the answer only has to appear somewhere in what the player types |
| equality | `input.to_lower() == answer` | the player must type the answer exactly |

Rather than contorting the prose to keep English words in it, **the mod patches the
comparisons**: each one accepts the English answer *and* its equivalents in the target
language. A solution found on an English-language forum still works.

### Acrostics

Three documents hide a key in their initials, and one of them states the rule
outright: *"the key for passage is the first letter of each passage"*. No tool that
searches for string comparisons can see them.

One of the three actually carries a puzzle answer. French does not spell the same
initials, so the new sequence is registered as an accepted answer, and
`tools/check_acrostics.py` refuses to build if a load-bearing acrostic changes without
being declared.

### Strings that are not text

**192 of the scene strings are never displayed: they are dictionary keys.** `Disc.text`
is an `@export` used to index `Texts.texts[…]`; translating it does not break a puzzle,
**it crashes the game**. `tools/godot/map_props.gd` maps each string to the property
that consumes it, and `tools/verify_scenes.py` rejects any change to a string wired
into a property the code reads.

`tools/godot/test_resourcesaver.gd` is the experiment that proved the game can write
its own translated scenes; it is kept because the finding is easy to doubt and cheap to
re-run.

---

## Architecture

The mod modifies **no game file**. It builds on
[GDPatch](https://github.com/GDPatch/GDPatch), a mod loader that injects at startup and
rewrites scripts in memory.

Three text sources, three mechanisms:

| Source | Volume | Mechanism |
|---|---|---|
| `Scripts/texts.gdc` — the 167 documents | 17,900 words | fully regenerated GDScript source |
| 17 other `.gdc` — location descriptions, lore, UI | 261 strings | text substitution on the decompiled source |
| 47 `.tscn` scenes — menus, terminals, HUD | 205 strings | rebuilt by the game itself, at first launch |

Two details that were expensive to discover:

- **Remaps.** Each scene exists as `Scenes/x.tscn.remap`, a pointer to
  `.godot/exported/<hash>/export-<md5>-x.scn`. Writing to `Scenes/x.tscn` does
  **nothing** — the remap redirects to the old file, with no error.
- **Silent failure.** When a patched script fails to parse, GDPatch keeps the original
  and says nothing. One misplaced straight quote left all 79 location descriptions in
  English for a whole cycle. `tools/gen_strings_lua.py` now rejects any translation
  containing a straight quote or a raw newline.

### How scenes are translated without shipping a single game file

This was the hard part, and it took three attempts.

A `PackedScene` keeps its strings in the `_bundled` property, where `variants` holds
the text and nodes reference it **by index**. The obvious move is to mutate
`variants[i]` at startup. It was implemented and measured: instantiating the 47
translated scenes in-game and reading back their node text gave **65 of 205 strings**,
against **180 of 205** for scene files written to disk. Two thirds of the interface
vanished, silently. That approach is dead.

What works is the third way: the game **is** a Godot engine. At first launch the mod
makes it load each scene, mutate `_bundled`, and write the result into its own mod
folder with `ResourceSaver`. From the second launch onwards those files are served,
and the score is 180 of 205 — identical to rewriting them offline.

Measured on a clean install:

```
launch 1   SCENES 47 scenes ecrites, 205 chaines, 0 hors champ, 0 echecs
launch 2   17 scripts : 261 strings applied, 0 misses
           180 / 205 scene strings present in the instantiated tree
```

Three consequences, and they are the whole point:

- the distributed mod carries **no file belonging to ChillCash** — 220 KB of French
  text and Lua, against 6.1 MB when scenes were shipped;
- it is **not tied to a game build**. The freshness marker follows the remap targets,
  which carry a content hash, so the scenes rebuild themselves when the game updates
  instead of silently reverting to English;
- a player needs **neither Godot nor Python**.

The 6.1 MB still exist — they are just generated on the player's disk, from the
player's own copy, and never travel.

### Portability

The mod contains only text (`.gd`, `.lua`, `.toml`) and Godot resources (`.scn`):
**no absolute paths, no platform references**. The GDPatch loader is published for
Windows, macOS and Linux.

Nothing in the mod is tied to a specific game build. The scenes are rebuilt from the
player's own pack whenever the game changes, and the string substitutions degrade
gracefully: if ChillCash rewrites a sentence, the substitution misses, the patcher logs
`MANQUE`, and that one line stays English. It ages, it does not break.

---

## Install — the player path

**The simplest way is the page itself.** Open `web/index.html`, tab *Installer la
traduction*: pick your language, point the browser at your game folder, done. On
Chrome and Edge it writes `GDPatch/mods/flux_<lang>/` for you; on Firefox it hands you
a zip that already has the right tree, so there is nothing to reorganise. Either way,
no terminal.

You still fetch the GDPatch loader yourself — its CDN sends no CORS header, and it
isn't ours to redistribute. The page takes it as a file drop and puts it in place.

The rest of this section is the same thing done by hand.

1. **The loader.** Get it for your platform from
   [the GDPatch releases](https://github.com/GDPatch/GDPatch/releases/latest) and drop
   it in the game folder — `libgdpatch_loader.so`, `gdpatch_loader.dll` or
   `libgdpatch_loader.dylib`. It is not redistributed here; it belongs to its authors.
2. On Linux and macOS, also get `run_with_gdpatch.sh` from
   [gdpatch.dev](https://gdpatch.dev/) and put it in the same place. It is required
   because the Steam install path contains a space and `LD_PRELOAD` splits on it.
3. **The translation.** Download the release for your language and unzip it, then:

   ```sh
   ./install.sh --depuis <unzipped folder> "<game folder>" fr
   ```

   Or copy the folder by hand to `<game folder>/GDPatch/mods/flux_fr`. That is all the
   script does, plus a couple of checks.
4. Steam launch options, on Linux and macOS: `./run_with_gdpatch.sh %command%`.
   On Windows there is nothing to do — the loader hooks itself.

**Launch the game twice.** The first launch builds the translated scenes from your own
copy — a few seconds, once — and the interface turns French on the second. They rebuild
themselves whenever the game updates, so you never have to think about it again.

What that first launch prints:

```
SCENES 47 scenes ecrites, 205 chaines, 0 hors champ, 0 echecs
SCENES fabriquees pour cette version du jeu — relance pour les voir.
```

The mod you downloaded is 220 KB. After that first launch it occupies about 6 MB on
your disk, all of it generated locally from files you already own.

### If you build it yourself

```sh
./build.sh "<game executable>" fr     # produces build/fr/
./install.sh "<game folder>" fr
```

This needs Godot 4.7 on your `PATH`, Python 3, and the GDPatch loader already installed
— `tools/dump_sources.sh` actually runs the game to decompile its scripts. It is the
path for adding a language or replaying the in-game puzzle checks, not for playing.

### Uninstall

`./install.sh --desinstaller "<game folder>"`.

The mod modifies no game file; it only adds three entries to the game folder:

```
libgdpatch_loader.so      (or .dll / .dylib)
run_with_gdpatch.sh
GDPatch/
```

Deleting those three and removing `./run_with_gdpatch.sh %command%` from the Steam
launch options restores the original game. A Steam file-integrity check does not remove
them either — they are files Steam does not know about, not modified files.

> **One Steam achievement unlocks on first launch, mod or no mod.**
> `text_manager.gd` marks the tutorial journal entry as read at startup, which counts
> as a passage found. That is the game, not the mod.

---

## Translate in your browser

`web/index.html` is a two-column editor — original on the left, editable translation on
the right. It is a static page: no server, no account, no data leaves your machine. It
can be published as-is on GitHub Pages.

**Nothing to install and nothing to run first.** You give it the game file —
`flux-empyrean.x86_64`, `Flux Empyrean.exe`, or the `.pck` if it is separate — and it
extracts the English text in your browser. The file is 827 MB and is never loaded whole:
the page reads the pack directory, then only the few hundred kilobytes that carry text.
It takes about a second.

What it recovers, measured on build 1.3.1: **167 documents (601 pages), 445 scene
strings, 426 code strings** — all of the translatable text.

It contains **no game text**, deliberately. The repository ships only `web/index/`, a
map made of page counts and SHA-1 fingerprints: enough to group 768 flat strings into
167 titled documents, and to know which string belongs to which line of which script,
without reproducing a line of the prose. That is what makes it publishable without
redistributing the author's work.

It is also what tells the full game from the demo, and this needs saying plainly: it is
**not a licence check** and does not pretend to be one. The translation is built from
*your* corpus; without the game, the editor simply has nothing to show. A short corpus
is flagged as probably being the demo.

The editor reproduces the guardrails:

- frozen segments are **read-only**, with the reason on hover;
- an answer word that disappears from your translation raises an immediate warning;
- a straight quote in a code string is flagged on the spot;
- `%s` markers are counted.

*Download* produces the three language files, ready to drop into `locales/<code>/`.
`scripts.json` comes out already fingerprinted.

*Propose to the project* does the same, then opens GitHub's upload page on the right
folder. GitHub forks the repository for you if you lack write access, and its upload
page opens the pull request — no token to paste, no server, and no size limit. The
button stays inert until `DEPOT` is filled in at the top of `web/editeur.js`: it
downloads the files and says so.

Two test suites check all of this against your own copy of the game:

```sh
python3 -m http.server 8731 --directory web &
node tests/recette_navigateur.mjs "<game executable>"   # the editor, in Firefox
node tests/recette_extraction.mjs "<game executable>"   # extraction, against Python
```

The first does a round trip: it loads `locales/fr/`, downloads again without editing,
and compares value by value. Playwright is not a dependency of this repository —
install it wherever you like and point `PLAYWRIGHT` at it.

---

## Add a language

`python3 tools/init_locale.py de es it` prepares empty-but-valid language folders. Each
one arrives with the **32 answer words that a translation will inevitably move**, listed
with empty alias arrays — every array left empty is a puzzle the player can only solve
in English. The **23 answer words that must never be touched** (numbers, proper nouns,
Xeretic words, cipher keys) are listed separately in `glossary.json`: translating
`minos` or `1034` closes the puzzle instead of opening it.

Twelve languages are already scaffolded: `de es it pt-BR ru pl tr nl ja ko zh-Hans uk`.
An empty language passes the checks and builds.


The engine is language-neutral; a language is **data**. Everything French lives in
`locales/fr/`; the record of game facts — locks, frozen segments, Vigenère keys — is
shared by every language, because it describes the game, not a translation.

```sh
cp -r locales/fr locales/de
# translate the JSON files, then:
LOCALE=de ./build.sh "<game executable>" de
```

`tools/BRIEF_TRADUCTEUR.md` is the brief given to the translators, including what must
stay English and why.

---

## Verify

```sh
python3 tools/verify_locale.py          # full check of one language
tools/check_ingame.sh                   # launches the game and reads the served corpus
```

`tools/ingame/qa_enigmes.gd` goes further: it instantiates each puzzle scene, injects an
answer into the input field, calls the game's own validation, and checks **the effect
specific to that puzzle** — a `solved` variable, a lamp turning green, a door lowering,
a local signal, a recorded discovery.

Current state, against build 1.3.1:

```
launch 1   SCENES 47 scenes ecrites, 205 chaines, 0 hors champ, 0 echecs
launch 2   17 scripts : 261 strings applied, 0 misses
           180 / 205 scene strings present in the instantiated tree
           0 parse errors, 0 puzzle patches unapplied
6 / 6 puzzles accept French and reject a wrong answer
frozen segments intact : 23 / broken : 0
```

One caveat on those numbers: the sandbox used to hold a copy of the game frozen at an
older date while the mod targeted the current Steam build, which produced one phantom
"missing string". Any in-game check should start by confirming `md5sum` matches between
the two.

`ETAT.md` (in French) keeps the detailed log: what the translators caught that the
tooling had missed, the arbitrations made, and the incidents — including the one where
the test harness unlocked Steam achievements by calling the game's own progression
functions.

---

## Licence and respect for the game

**The tooling** redistributes no game content. It reads the pack of your own copy, and
everything it extracts stays in `work/`, which is excluded from the repository. The
language files themselves are indexed by **fingerprint** rather than by English text:
`scripts.json` and `decrypt.json` contain no sentence from the game, and the tool finds
them in your copy.

`locales/fr/documents.json` holds the French text. Measured against the corpus, it
contains 1,732 characters of English prose out of 99,182 — short quotations inside
translator notes, justifying a choice. The rest of the English in it is either frozen
segments, which are ciphertext rather than prose and must be byte-identical, or titles
and dictionary keys the game requires to stay English.

**The translation itself is a derivative work.** Under French law, translating requires
the consent of the author of the original work (CPI art. L.122-4, and L.122-6 for
software); being free of charge and culturally motivated changes nothing.
`JURIDIQUE.md` (in French) details the situation and holds the message to ChillCash
asking for permission.

Until that permission is given, this repository's recommendation is simple: **publish
the tooling, hold the language data**. That is what makes the "community tool" framing
honest — the tool is ours, the translation is not.

ChillCash is credited as the author of the original work. If ChillCash would rather this
did not exist, it comes down.

### Third-party code

`web/vendor/fzstd.js` is [fzstd](https://github.com/101arrowz/fzstd) by 101arrowz, MIT
licence, vendored so the editor works offline. It decompresses the zstd frames inside
Godot's compiled scripts.

The GDPatch loader is **not** redistributed here: the toolkit points at its authors'
releases instead.
