-- Trois interventions, une par source de texte :
--   1. le corpus des 167 documents, remplace en bloc par une source regeneree ;
--   2. les chaines noyees dans le code des autres scripts, par substitution ;
--   3. les comparaisons d'enigmes, reecrites pour accepter les reponses FR.
--
-- Les scenes ne sont pas livrees : le GDScript ajoute a texts.gd les fait
-- fabriquer au jeu, au premier lancement, depuis sa propre copie. Le mod ne
-- transporte donc aucun fichier du jeu et ne vise aucune build en particulier.
local utils = require("gdpatch.utils")
local dir = GDPatch.get_mod_directory()

GDPatch.patch_script_as_text("Scripts/texts.gdc", function(ctx, src)
	local f = io.open(dir .. "/texts.gd", "r")
	if not f then
		print("texts.gd introuvable, corpus laisse en anglais")
		return src
	end
	local fr = f:read("a")
	f:close()
	-- Seul le patcher connait le chemin du mod ; le GDScript en a besoin pour y
	-- ecrire les scenes qu'il fabrique.
	--
	-- Sous Windows ce chemin porte des antislashs, et "C:\Users\..." donne \U, \m,
	-- \f : des echappements invalides en GDScript. Le script entier etait rejete,
	-- donc ni corpus traduit ni scenes fabriquees -- en silence, comme toujours.
	-- Godot accepte les slashes avant sur toutes les plateformes, on normalise.
	local chemin = dir:gsub("\\", "/")
	fr = fr:gsub("@@MOD_DIR@@", (chemin:gsub("%%", "%%%%")))

	-- Le texte d'origine, pris dans le pack du joueur et gardé sous un autre nom.
	-- C'est ce qui permet la bascule F1 sans distribuer une ligne de l'anglais :
	-- il ne quitte jamais sa machine. La declaration tient sur une seule ligne.
	local vo = src:match("\n(var texts[^\n]*)")
	if vo then
		vo = vo:gsub("^var texts", "var texts_vo", 1)
		fr = fr:gsub("@@TEXTS_VO@@", (vo:gsub("%%", "%%%%")), 1)
		print("VO texte d'origine conserve (" .. #vo .. " octets), F1 pour basculer")
	else
		fr = fr:gsub("@@TEXTS_VO@@", "var texts_vo: Dictionary = {}", 1)
		print("VO texte d'origine introuvable, bascule F1 desactivee")
	end
	print("CORPUS-FR " .. #fr .. " octets")
	return fr
end)


-- Les chaines noyees dans le code, et le dictionnaire qu'on en tire.
--
-- Jusqu'ici on jetait l'anglais au moment meme ou on l'avait en main : la
-- substitution le remplacait et il disparaissait du programme compile. F1 ne
-- pouvait donc rien rebasculer -- il n'y avait plus rien a echanger.
--
-- On le range desormais dans `vo_code.json`, a cote du mod, exactement comme
-- les scenes rangent le leur. Ce fichier ne quitte pas la machine du joueur.
--
-- On n'enregistre que les substitutions **reussies** : une paire qui ne s'est
-- pas appliquee n'est pas dans le jeu, et la faire figurer donnerait un compte
-- flatteur et faux. Et seulement celles marquees relevables par
-- gen_strings_lua.py -- les clés de la logique du jeu et les chaines a format
-- en sont exclues au build.
local vo_code = {}

local function json_chaine(v)
	local echappe = v:gsub('[%c"\\]', function(c)
		if c == '"' then return '\\"' end
		if c == "\\" then return "\\\\" end
		if c == "\n" then return "\\n" end
		if c == "\r" then return "\\r" end
		if c == "\t" then return "\\t" end
		return string.format("\\u%04x", c:byte())
	end)
	return '"' .. echappe .. '"'
end

-- Reecrit a chaque script patche : GDPatch n'offre pas de fin de course, et le
-- fichier est petit. Le dernier passage laisse le relevé complet.
local function ecrire_vo_code()
	local f = io.open(dir .. "/vo_code.json", "w")
	if not f then return end
	local morceaux, n = {}, 0
	for traduite, origine in pairs(vo_code) do
		n = n + 1
		morceaux[n] = json_chaine(traduite) .. ":" .. json_chaine(origine)
	end
	f:write("{" .. table.concat(morceaux, ",") .. "}")
	f:close()
	return n
end

local chaines = dofile(dir .. "/strings.lua")
for script, paires in pairs(chaines) do
	GDPatch.patch_script_as_text(script, function(ctx, src)
		local out, faits, manques = src, 0, 0
		for _, paire in ipairs(paires) do
			local remplace, n = out:gsub(utils.escape(paire[1]), utils.escape(paire[2], true))
			if n > 0 then
				out = remplace
				faits = faits + 1
				-- paire[3] : relevable. Absent sur un strings.lua d'avant cette
				-- version, auquel cas on ne releve rien plutot que de relever
				-- une clé et de casser une enigme.
				if paire[3] == true then vo_code[paire[2]] = paire[1] end
			else
				manques = manques + 1
				print("MANQUE " .. ctx.path .. " :: " .. paire[1]:sub(1, 50))
			end
		end
		print("CHAINES " .. ctx.path .. " : " .. faits .. " ok, " .. manques .. " manques")
		local total = ecrire_vo_code()
		if total then print("VO-CODE " .. total .. " paires relevees") end
		return out
	end)
end

local reponses = dofile(dir .. "/answers.lua")
for script, paires in pairs(reponses.remplacements) do
	GDPatch.patch_script_as_text(script, function(ctx, src)
		local out = src
		for _, paire in ipairs(paires) do
			local remplace, n = out:gsub(utils.escape(paire[1]), utils.escape(paire[2], true))
			if n > 0 then out = remplace
			else print("ENIGME NON APPLIQUEE " .. ctx.path) end
		end
		if reponses.aides[script] then out = out .. reponses.aides[script] end
		return out
	end)
end
